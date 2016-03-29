#!/usr/bin/env bash

echo "Validate $1"

PART_FILE=$(ls pst-extract/$1/part-* | sort -n | head -1)

echo "Checking part file for existence: $PART_FILE"

if [ ! -s "$PART_FILE" ]
then
    echo "FAILED: No data available in $PART_FILE.  Newman Pipeline halted."
    exit 3
fi

exit 0
