#!/bin/bash
# ~/.bashrc defines settings for users when running subshells.

# If not running interactively, don't apply any configuration.
[[ $- != *i* ]] && return

export BASHRCD=$HOME/.bashrc.d

source $BASHRCD/main.sh

