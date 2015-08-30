#!/bin/sh

git shortlog -sn | cut -f2 > CONTRIBUTORS
