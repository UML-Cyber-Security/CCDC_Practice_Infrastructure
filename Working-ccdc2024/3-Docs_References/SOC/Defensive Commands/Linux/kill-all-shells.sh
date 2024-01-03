#!/bin/bash

shells=( fish zsh dash ksh tcsh csh sh bash)

for i in "${shells[@]}" 
do
    pkill -9 -f $i
done