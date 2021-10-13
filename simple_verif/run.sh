#!/bin/bash

outputdir="../output"

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -o|--outputdir) outputdir="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done


xrun -elaborate -sv -64 -timescale "1ns/1ps" -vtimescale "1ns/1ps"    -l xrun.log -errormax 1 \
  $outputdir/*.v \
  $outputdir/*.sv \
  ../vsrc/*.v \
  ../vsrc/*.sv
  
