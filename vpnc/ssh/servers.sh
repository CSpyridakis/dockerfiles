#!/bin/bash

# Include these aliases to your 
alias ssh_target="ssh -o "IdentitiesOnly=yes" -i ~/.ssh/target_key -J docker@172.17.0.2 target-user@target-IP"