#!/bin/bash

if command -v docker &> /dev/null
    UID=${UID} GID=${GID} docker compose up -d
elif command -v podman &> /dev/null
    UID=${UID} GID=${GID} podman compose up -d
else
    echo "A known container runtime is not available"
fi