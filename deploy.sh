#!/bin/bash

for i in $(ls .github/workflows|grep deploy|sed '/deploy-rs/d')
do
    gh workflow run ${i}
done