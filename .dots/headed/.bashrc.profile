#!/bin/bash
# ~/.bashrc.profile defines a dots-profile specific rc to be executed before any other rcs.

# If not running interactively, don't apply any configuration.
[[ $- != *i* ]] && return

export BASHRCD=$HOME/.bashrc.d

source $BASHRCD/main.sh

