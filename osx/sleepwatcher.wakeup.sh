#!/bin/sh

if [[ `hostname` == 'macbook.local' ]]; then
  osascript -e 'set volume 0'
fi

if [[ `hostname` == 'macpro.local' ]]; then
  /usr/local/bin/api lcd on
fi
