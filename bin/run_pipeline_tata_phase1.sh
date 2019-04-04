#!/usr/bin/env bash

set +x
set -e
echo "===========================================$0 $@"

START=$(date +%s)

PST_PREFIX=$1

./bin/run_spark_tika_scala.sh ${PST_PREFIX}

./bin/run_binary_extraction_merge.sh ${PST_PREFIX}

./bin/run_spark_content_split.sh  ${PST_PREFIX}

./bin/run_spark_rmhtml.sh ${PST_PREFIX}

END=$(date +%s)
DIFF=$(( $END - $START ))
echo "It took $DIFF seconds"
