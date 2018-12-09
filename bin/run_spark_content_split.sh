#!/usr/bin/env bash

set +x
set -e
echo "===========================================$0 $@"

START=$(date +%s)

PST_PREFIX=$1
# -v  : Filter broken json.  Test each json object and output broken objects to tmp/failed.
FLAG_VALIDATE_JSON=$2

INPUT_DIR=spark-emails-attach
# Changed for testing
#INPUT_DIR=spark-emails-attach-exif
OUTPUT_DIR=spark-emails-text
if [[ -d "pst-extract/${PST_PREFIX}/$OUTPUT_DIR" ]]; then
    rm -rf "pst-extract/${PST_PREFIX}/$OUTPUT_DIR"
fi
OUTPUT_DIR2=spark-emails-attachments
if [[ -d "pst-extract/${PST_PREFIX}/$OUTPUT_DIR2" ]]; then
    rm -rf "pst-extract/${PST_PREFIX}/$OUTPUT_DIR2"
fi

spark-submit --master local[*] --driver-memory 8g --conf spark.storage.memoryFraction=.8 --files spark/filters.py spark/attachment_split.py pst-extract/${PST_PREFIX}/${INPUT_DIR} pst-extract/${PST_PREFIX}/$OUTPUT_DIR  pst-extract/${PST_PREFIX}/${OUTPUT_DIR2} ${FLAG_VALIDATE_JSON}

#./bin/validate_lfs.sh $OUTPUT_DIR
END=$(date +%s)
DIFF=$(( $END - $START ))
echo "It took $DIFF seconds"
