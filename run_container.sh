#!/usr/bin/env bash
apptainer exec \
  --bind $PWD:/mnt \
  ${1:-my_container.sif} \
  bash
