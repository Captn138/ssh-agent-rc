What the `install.sh` script does :

- Add this block to you rc shell file
```bash
findpid=$(ps aux | grep ssh-agent | grep -v grep | xargs | cut -d ' ' -f 2)

if [ -z "$findpid" ]
        then
        eval $(ssh-agent -t 1h) > /dev/null
else
        export SSH_AGENT_PID=$findpid
        findsock=$(($findpid - 1))
        export SSH_AUTH_SOCK=$(find /tmp/ -type s -name "agent.*" 2> /dev/null | grep $findsock)
fi

unset findpid findsock
```
This searches for a pid for `ssh-agent`. If it finds it, then it searches for values to fill the `SSH_AGENT_PID` and `SSH_AUTH_SOCK` env vars. Else, it runs a new `ssh-agent`.

- Add this line to the beginning of your `~/.ssh/config` file
```
AddKeysToAgent yes
```
This allows `ssh` to forward your key to the agent once you unlock it.
