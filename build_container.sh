#!/usr/bin/env bash
apptainer build --fakeroot ${1:-my_container.sif} ${2:-my_definition.def}
