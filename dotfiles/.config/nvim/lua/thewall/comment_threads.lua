-- Telescope pickers over AUTHOR:/CLAUDE: comment threads (see author_comment
-- in lazy.lua). Unlike TodoTelescope, which lists every matching line, these
-- group lines into threads and comments so each comment shows up once:
--
--   thread   adjacent comment lines, e.g. AUTHOR / CLAUDE / AUTHOR / CLAUDE
--   comment  one voice's turn: consecutive lines with the same keyword, plus
--            continuation lines that don't repeat it (`//   more text`)
--
-- pick({ keyword = "CLAUDE", open_only = true }) lists only threads whose last
-- comment is CLAUDE's, i.e. replies still waiting on me.

local M = {}

local KEYWORDS = { "AUTHOR", "CLAUDE" }

-- Returns keyword, column, comment marker and text for a line that carries a
-- keyword. The marker is the token just before the keyword (`//`, `#`, `--`,
-- `*`, `<!--`), used to recognise continuation lines below it.
local function parse(line)
	local best
	for _, kw in ipairs(KEYWORDS) do
		local s, e = line:find("%f[%w_]" .. kw .. ":")
		if s and (not best or s < best.s) then
			best = { kw = kw, s = s, e = e }
		end
	end
	if not best then
		return nil
	end
	local marker = line:sub(1, best.s - 1):match("(%S+)%s*$") or ""
	return best.kw, best.s, marker, line:sub(best.e + 1)
end

local function clean(text)
	text = text:gsub("%s*%-%->%s*$", ""):gsub("%s*%*/%s*$", "")
	return vim.trim(text)
end

-- Splits a file's lines into threads, each a list of comments.
local function threads_in(lines)
	local threads = {}
	local i = 1
	while i <= #lines do
		local kw, col, marker, text = parse(lines[i])
		if not kw then
			i = i + 1
		else
			local comments = { { kw = kw, lnum = i, col = col, text = { clean(text) } } }
			i = i + 1
			while i <= #lines do
				local nkw, ncol, nmarker, ntext = parse(lines[i])
				local last = comments[#comments]
				if nkw and vim.trim(lines[i]:sub(1, ncol - 1)) ~= nmarker then
					break -- trailing comment after code starts its own thread
				elseif nkw then
					if nkw == last.kw then
						table.insert(last.text, clean(ntext))
					else
						table.insert(comments, { kw = nkw, lnum = i, col = ncol, text = { clean(ntext) } })
					end
					marker = nmarker
				elseif marker ~= "" and vim.startswith(vim.trim(lines[i]), marker) then
					table.insert(last.text, clean(vim.trim(lines[i]):sub(#marker + 1)))
				else
					break
				end
				i = i + 1
			end
			table.insert(threads, comments)
		end
	end
	return threads
end

local function collect(opts)
	local cwd = vim.uv.cwd()
	local files = vim.fn.systemlist({ "rg", "--color=never", "--files-with-matches", "-e", [[\b(AUTHOR|CLAUDE):]] })
	table.sort(files)

	local results = {}
	for _, rel in ipairs(files) do
		local path = cwd .. "/" .. rel
		local ok, lines = pcall(vim.fn.readfile, path)
		for _, comments in ipairs(ok and threads_in(lines) or {}) do
			for idx, c in ipairs(comments) do
				local latest = idx == #comments
				if c.kw == opts.keyword and (latest or not opts.open_only) then
					table.insert(results, {
						filename = path,
						rel = rel,
						lnum = c.lnum,
						col = c.col,
						kw = c.kw,
						text = table.concat(vim.tbl_filter(function(t)
							return t ~= ""
						end, c.text), " "),
					})
				end
			end
		end
	end
	return results
end

function M.pick(opts)
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values

	local icons = { AUTHOR = "󰠗", CLAUDE = "󰚩" }
	local results = collect(opts)
	local pad = 0
	for _, r in ipairs(results) do
		pad = math.max(pad, #(r.rel .. ":" .. r.lnum))
	end

	pickers
		.new({}, {
			prompt_title = (opts.open_only and "Open " or "") .. opts.keyword .. " comments",
			finder = finders.new_table({
				results = results,
				entry_maker = function(r)
					local location = r.rel .. ":" .. r.lnum
					return {
						value = r,
						ordinal = location .. " " .. r.text,
						filename = r.filename,
						lnum = r.lnum,
						col = r.col,
						text = r.text,
						-- Built by hand: entry_display needs the results window to exist already.
						display = function()
							local icon = icons[r.kw] .. " "
							local loc = location .. string.rep(" ", pad - #location) .. "  "
							return icon .. loc .. r.text,
								{
									{ { 0, #icon }, "TodoFg" .. r.kw },
									{ { #icon, #icon + #location }, "TelescopeResultsComment" },
								}
						end,
					}
				end,
			}),
			sorter = conf.generic_sorter({}),
			previewer = conf.grep_previewer({}),
		})
		:find()
end

return M
