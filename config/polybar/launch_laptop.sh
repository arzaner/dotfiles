#!/usr/bin/env bash

killall -q polybar
while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

{ while :; do polybar laptop; done } & disown