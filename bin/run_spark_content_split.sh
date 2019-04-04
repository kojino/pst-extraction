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
if [[ -d "pst-extract/$OUTPUT_DIR/${PST_PREFIX}" ]]; then
    rm -rf "pst-extract/$OUTPUT_DIR/${PST_PREFIX}"
fi
OUTPUT_DIR2=spark-emails-attachments
if [[ -d "pst-extract/$OUTPUT_DIR2/${PST_PREFIX}" ]]; then
    rm -rf "pst-extract/$OUTPUT_DIR2/${PST_PREFIX}"
fi

spark-submit --master local[*] --driver-memory 16g --conf spark.storage.memoryFraction=.8 --files spark/filters.py spark/attachment_split.py pst-extract/${INPUT_DIR}/${PST_PREFIX} pst-extract/$OUTPUT_DIR/${PST_PREFIX}  pst-extract/${OUTPUT_DIR2}/${PST_PREFIX} ${FLAG_VALIDATE_JSON}

#./bin/validate_lfs.sh $OUTPUT_DIR
END=$(date +%s)
DIFF=$(( $END - $START ))
echo "It took $DIFF seconds"
