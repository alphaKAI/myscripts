#!/usr/bin/env zsh

COMMAND_LIST=(
  amv
  ctl
  ctwi
  cxz
  doco
  sizer
  streamfilter
  xxz
)

cd bin

for command_name in $COMMAND_LIST; do
  cmd="ln -s ~/.myscripts/$command_name/$command_name $command_name"
  echo "link with : $cmd"
  eval $cmd
done
