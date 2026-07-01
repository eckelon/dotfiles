#!/bin/bash

hyperfine --warmup 3 --runs 10 'zsh -i -c exit'
