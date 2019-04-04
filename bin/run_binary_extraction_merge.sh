#!/usr/bin/env bash

set -e
set +x

echo "===========================================$0 $@"
#
#Mode should be either left off or --docex_mode which will enable copy of extracted data into the body field
#
START=$(date +%s)

PST_PREFIX=$1
# -v  : Filter broken json.  Test each json object and output broken objects to tmp/failed.
FLAGS_VALIDATE_JSON=$2  
# -d : docex mode copies extracted text to the email body for further analysis.  Only use with docex.  This will overwrite the email body!
FLAGS_DOCEX_MODE=$3 
echo "mode=$RUN_FLAGS"

INPUT_RIGHT_SIDE_DIRS=pst-extract/spark-attach/${PST_PREFIX}
#,pst-extract/ocr_output/
OUTPUT_DIR=spark-emails-attach
if [[ -d "pst-extract/$OUTPUT_DIR/${PST_PREFIX}" ]]; then
    rm -rf "pst-extract/$OUTPUT_DIR/${PST_PREFIX}"
fi
#OUTPUT_DIR2=spark-emails-attach-classification
#if [[ -d "pst-extract/$OUTPUT_DIR2/${PST_PREFIX}" ]]; then
#    rm -rf "pst-extract/$OUTPUT_DIR2/${PST_PREFIX}"
#fi

#OUTPUT_DIR_FINAL=spark-emails-attach
#if [[ -d "pst-extract/$OUTPUT_DIR_FINAL/${PST_PREFIX}" ]]; then
#    rm -rf "pst-extract/$OUTPUT_DIR_FINAL/${PST_PREFIX}"
#fi

spark-submit --master local[*] --driver-memory 32g --conf spark.storage.memoryFraction=.8 --files spark/filters.py spark/attachment_join.py pst-extract/pst-json/${PST_PREFIX}/ $INPUT_RIGHT_SIDE_DIRS pst-extract/$OUTPUT_DIR/${PST_PREFIX} $FLAGS_VALIDATE_JSON $FLAGS_DOCEX_MODE
#./bin/validate_lfs.sh $OUTPUT_DIR

# TODO:Image classification module need to be downloaded. See bin/run_human_receipt_detection_harness.sh

#spark-submit --master local[*] --driver-memory 16g --conf spark.storage.memoryFraction=.8 --files spark/filters.py spark/attachment_join.py pst-extract/${PST_PREFIX}/$OUTPUT_DIR pst-extract/${PST_PREFIX}/spark-image-classifier/ pst-extract/${PST_PREFIX}/$OUTPUT_DIR2 $RUN_FLAGS
#./bin/validate_lfs.sh $OUTPUT_DIR2

# TODO: OCR module is not there.
#spark-submit --master local[*] --driver-memory 16g --conf spark.storage.memoryFraction=.8 --files spark/filters.py spark/attachment_join.py pst-extract/$OUTPUT_DIR2 pst-extract/ocr_output/ pst-extract/$OUTPUT_DIR_FINAL $RUN_FLAGS
#./bin/validate_lfs.sh $OUTPUT_DIR_FINAL
END=$(date +%s)
DIFF=$(( $END - $START ))
echo "It took $DIFF seconds"
