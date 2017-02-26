#!/bin/bash
custuptimevar=$(sed 's_.*up[^ ]* \([^,]*\),.*_\1_' <<< $(uptime))
custuptimeleft="up: $custuptimevar, remaining: $(sed 's_Battery[^,]*, \([^,]*\), \([^ ]*\).*_\2 (\1)_' <<< $(acpi))"
echo "$custuptimeleft"
exit 0
