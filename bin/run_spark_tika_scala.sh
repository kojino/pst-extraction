#!/usr/bin/env bash

set -e
set +x

START=$(date +%s)

PST_PREFIX=$1

echo "===========================================$0"

OUTPUT_DIR=spark-attach
if [[ -d "pst-extract/$OUTPUT_DIR/${PST_PREFIX}" ]]; then
    rm -rf "pst-extract/$OUTPUT_DIR/${PST_PREFIX}"
fi

spark-submit --master local[*] --driver-memory 32g --jars lib/tika-app-1.10.jar,lib/commons-codec-1.10.jar --conf spark.storage.memoryFraction=.8 --class newman.Driver lib/tika-extract_2.10-1.0.1.jar pst-extract/pst-json/${PST_PREFIX}/ pst-extract/$OUTPUT_DIR/${PST_PREFIX} etc/exts.txt

#./bin/validate_lfs.sh $OUTPUT_DIR
END=$(date +%s)
DIFF=$(( $END - $START ))
echo "It took $DIFF seconds"
