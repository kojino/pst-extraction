#!/usr/bin/env bash

set +x
set -e
echo "===========================================$0"

OUTPUT_DIR=spark-emails-text
if [[ -d "pst-extract/$OUTPUT_DIR" ]]; then
    rm -rf "pst-extract/$OUTPUT_DIR"
fi

if [[ -d "pst-extract/spark-emails-attachments" ]]; then
    rm -rf "pst-extract/spark-emails-attachments"
fi

spark-submit --master local[*] --driver-memory 8g --conf spark.storage.memoryFraction=.8 spark/attachment_split.py pst-extract/spark-emails-attach-exif pst-extract/$OUTPUT_DIR  pst-extract/spark-emails-attachments

./bin/validate_lfs.sh $OUTPUT_DIR
