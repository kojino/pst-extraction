#!/usr/bin/env bash

echo "===========================================$0 $@"

START=$(date +%s)

OUTPUT_DIR=spark-emails-sentiment
if [[ -d "pst-extract/$OUTPUT_DIR" ]]; then
    rm -rf "pst-extract/$OUTPUT_DIR"
fi

spark-submit --master local[*] --driver-memory 16g --conf spark.storage.memoryFraction=.8 --files spark/filters.py spark/sentiment.py --input_path pst-extract/spark-emails-text-rmhtml --output_path pst-extract/$OUTPUT_DIR

END=$(date +%s)
DIFF=$(( $END - $START ))
echo "It took $DIFF seconds"
#./bin/validate_lfs.sh $OUTPUT_DIR
