#!/bin/bash

for file in `find $1 -type f`; do md5=`md5sum $file|gawk '{print $1}'`; ln -s $file $md5; done
