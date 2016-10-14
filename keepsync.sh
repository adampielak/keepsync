#!/bin/bash

#
# Keep local and remote repository up to date using fswatch and rsync
# Uses .gitignore files to ignore unwanted files
#
# The MIT License (MIT) Copyright (c) 2015 Antti Jaakkola

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


SOURCE="${1}"
DESTINATION="${2}"

if [ -z "$SOURCE" ] || [ -z "$DESTINATION" ]
then
	echo "Usage $0 source destination"
	exit 1
fi

shift
shift

OPTS=""

EXTRAOPTS="$(find $SOURCE -maxdepth 2 -type f -name '.gitignore' -exec echo -n '--exclude-from={} ' \;)"

if [ ! -z "$1" ]
then
	OPTS="$@"
fi

function do_rsync {
	rsync --exclude=pkg/ --exclude=.git/ --exclude=*.pyc --exclude=.idea/ --exclude=env/ -av ${OPTS} ${EXTRAOPTS} "$SOURCE" "$DESTINATION";
}

set -x

do_rsync

fswatch -o "$SOURCE" |while read; do do_rsync; done
