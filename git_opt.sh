#!/bin/bash
commitStr =$1
git add .
git commit -m commitStr
git push origin master
