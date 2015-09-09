#!/bin/bash

echo -e "number of files: "
find ./ -type f |wc -l

echo -e "number of directories: "
find ./ -type d |wc -l

echo -e "number of links: "
find ./ -type l |wc -l

