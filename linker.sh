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
  echo "link command: ln -s ~/.myscripts/$command_name/$command_name $command_name"
done
