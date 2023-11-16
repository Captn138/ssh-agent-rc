#!/usr/bin/bash

cat << EOI >> ".$(echo $SHELL | rev | cut -d / -f 1 | rev)rc"

findpid=\$(ps aux | grep ssh-agent | grep -v grep | xargs | cut -d ' ' -f 2)

if [ -z "\$findpid" ]
        then
        eval \$(ssh-agent -t 1h) > /dev/null
else
        export SSH_AGENT_PID=\$findpid
        findsock=\$((\$findpid - 1))
        export SSH_AUTH_SOCK=\$(find /tmp/ -type s -name "agent.*" 2> /dev/null | grep \$findsock)
fi

unset findpid findsock
EOI

echo -e "AddKeysToAgent yes\n" > /tmp/sshconfig
cat ~/.ssh/config >> /tmp/sshconfig
cat /tmp/sshconfig > ~/.ssh/config
