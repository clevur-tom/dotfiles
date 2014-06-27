#!/bin/sh
# Replace placeholders with work info

SECRET1=""
SECRET2=""

find ./ -type f -exec sed -i 's/<secret1>/'$SECRET1'/' {} \;
find ./ -type f -exec sed -i 's/<secret2>/'$SECRET2'/' {} \;

unset SECRET1
unset SECRET2
