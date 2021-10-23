SYSINFO
#!/bin/bash

#if the research directory exists do nothing, if it does not create it

if [ -d ~/research ]
then
    echo the ~/research exists
else [ mkdir ~/research ]  
fi

#if the sys_info.txt exists do nothing, if it does remove it
if [ -f ~/research/sys_info.txt ]
then
    echo the sys_info.txt exists
else
    [ rm sys_info.txt ]
fi

