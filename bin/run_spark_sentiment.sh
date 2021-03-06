#!/usr/bin/env bash

echo "===========================================$0 $@"

START=$(date +%s)

PST_PREFIX=$1

OUTPUT_DIR=spark-emails-sentiment
if [[ -d "pst-extract/$OUTPUT_DIR/$PST_PREFIX" ]]; then
    rm -rf "pst-extract/$OUTPUT_DIR/$PST_PREFIX"
fi

spark-submit --master local[*] --driver-memory 32g --conf spark.storage.memoryFraction=.8 --files spark/filters.py spark/sentiment.py --input_path pst-extract/spark-emails-text-rmhtml/$PST_PREFIX --output_path pst-extract/$OUTPUT_DIR/$PST_PREFIX

END=$(date +%s)
DIFF=$(( $END - $START ))
echo "It took $DIFF seconds"
#./bin/validate_lfs.sh $OUTPUT_DIR
