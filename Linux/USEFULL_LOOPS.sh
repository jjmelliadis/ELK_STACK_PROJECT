#!/bin/bash
path=('/etc/shadow' '/etc/passwd')

for paths in ${path[@]};
do
    ls -lah $path >> $output
Done

