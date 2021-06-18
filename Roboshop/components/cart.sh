#!/bin/bash

source components/common.sh
rm -f /tmp/Roboshop.log
set-hostname cart

NODEJS "cart"

