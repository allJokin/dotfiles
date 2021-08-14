#!/bin/bash

type brew > /dev/null 2>&1
if [ $? -gt 0 ]; then
    echo brew not found
    exit 1
fi

echo brew
brew install anyenv