-- Branch review mode: diff everything on this branch against where it forked
-- from origin/master (or origin/main), instead of stepping commit by commit.
--
--   <leader>gr  toggle review mode: gitsigns base -> merge-base, changed lines
--               highlighted, quickfix list of every changed file (<CR> opens it)
--   <leader>go  toggle the old version inline (deleted/changed-from lines as
--               virtual lines under each hunk)
--   ]h / [h     next/prev hunk (from gitsigns.lua); ]q / [q next/prev file
--
-- The diff is merge-base vs working tree, so uncommitted edits are included
-- and commits landing on master since you branched are not.

local gs = require("gitsigns")

local review_base = nil

local function git(args)
	local out = vim.fn.systemlist(vim.list_extend({ "git" }, args))
	if vim.v.shell_error ~= 0 then
		return nil
	end
	return out
end

local function find_base()
	for _, ref in ipairs({ "origin/master", "origin/main" }) do
		local out = git({ "merge-base", "HEAD", ref })
		if out and out[1] then
			return out[1], ref
		end
	end
end

-- gitsigns has no base blob to diff a brand-new file against, so it shows no
-- signs there; the label tells you the whole file is new.
local labels =
	{ A = "new file (no signs, all of it is new)", M = "modified", R = "renamed", C = "copied", T = "type changed" }

local function changed_files_qf(root, base)
	local items = {}
	for _, line in ipairs(git({ "-C", root, "diff", "--name-status", base }) or {}) do
		local parts = vim.split(line, "\t", { plain = true })
		local status = parts[1]:sub(1, 1)
		-- Deleted files have nothing to open; renames list the new path last.
		if status ~= "D" then
			table.insert(items, {
				filename = root .. "/" .. parts[#parts],
				lnum = 1,
				text = labels[status] or status,
			})
		end
	end
	-- Untracked files are part of "what changed" too.
	for _, path in ipairs(git({ "-C", root, "ls-files", "--others", "--exclude-standard" }) or {}) do
		table.insert(
			items,
			{ filename = root .. "/" .. path, lnum = 1, text = "untracked (no signs, all of it is new)" }
		)
	end
	return items
end

local function review_off()
	review_base = nil
	gs.change_base(nil, true)
	gs.toggle_linehl(false)
	gs.toggle_word_diff(false)
	gs.toggle_deleted(false)
	vim.cmd("cclose")
	vim.notify("Review mode off (gitsigns base back to index)")
end

local function review_on()
	local root = (git({ "rev-parse", "--show-toplevel" }) or {})[1]
	if not root then
		vim.notify("Not in a git repo", vim.log.levels.WARN)
		return
	end
	local base, ref = find_base()
	if not base then
		vim.notify("No origin/master or origin/main to diff against", vim.log.levels.WARN)
		return
	end

	review_base = base
	gs.change_base(base, true)
	gs.toggle_linehl(true)
	gs.toggle_word_diff(true)

	local items = changed_files_qf(root, base)
	vim.fn.setqflist({}, " ", {
		title = ("Changed vs %s (%s)"):format(ref, base:sub(1, 8)),
		items = items,
	})
	vim.cmd("copen")
	vim.notify(("Review mode: %d files changed vs %s"):format(#items, ref))
end

vim.keymap.set("n", "<leader>gr", function()
	if review_base then
		review_off()
	else
		review_on()
	end
end, { desc = "Toggle branch review mode (vs origin/master)" })

vim.keymap.set("n", "<leader>go", function()
	local on = gs.toggle_deleted()
	gs.toggle_word_diff(on or review_base ~= nil)
end, { desc = "Toggle old version inline" })
