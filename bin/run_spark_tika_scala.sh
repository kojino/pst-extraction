#!/usr/bin/env bash

set -e
set +x

START=$(date +%s)

PST_PREFIX=$1

echo "===========================================$0"

OUTPUT_DIR=spark-attach
if [[ -d "pst-extract/${PST_PREFIX}/$OUTPUT_DIR" ]]; then
    rm -rf "pst-extract/${PST_PREFIX}/$OUTPUT_DIR"
fi

spark-submit --master local[*] --driver-memory 8g --jars lib/tika-app-1.10.jar,lib/commons-codec-1.10.jar --conf spark.storage.memoryFraction=.8 --class newman.Driver lib/tika-extract_2.10-1.0.1.jar pst-extract/${PST_PREFIX}/pst-json/ pst-extract/${PST_PREFIX}/$OUTPUT_DIR etc/exts.txt

#./bin/validate_lfs.sh $OUTPUT_DIR
END=$(date +%s)
DIFF=$(( $END - $START ))
echo "It took $DIFF seconds"
