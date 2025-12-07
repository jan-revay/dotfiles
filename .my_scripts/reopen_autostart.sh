#!/bin/bash -x
# . ../initPC/prelude.sh
#
#
# TODO find the best method https://chatgpt.com/share/6935527c-ab20-800d-9afe-d9ccfda9e3cc

# TODO - ChatGPT and Claude code review
# TODO - interpret flags in the exec

for f in ~/.config/autostart/*.desktop; do
    enabled=$(grep -E '^X-GNOME-Autostart-enabled=' "$f" | cut -d= -f2)

    echo $enabled
    # Default is enabled if the key is missing
    if [ -z "$enabled" ] || [ "$enabled" = "true" ]; then
        exec_line=$(grep -E '^Exec=' "$f" | sed 's/^Exec=//')

        if [ -n "$exec_line" ]; then
            bash -c "$exec_line" &
        fi
    fi
done

