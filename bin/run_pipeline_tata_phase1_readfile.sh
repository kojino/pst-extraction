#!/usr/bin/env bash

set +x
set -e
echo "===========================================$0 $@"

START=$(date +%s)

FILE=$1


while read -r LINE; do

echo "Processing >>>>>>>>" $LINE

#./bin/run_spark_tika_scala.sh ${PST_PREFIX}

#./bin/run_binary_extraction_merge.sh ${PST_PREFIX}

#./bin/run_spark_content_split.sh  ${PST_PREFIX}

#./bin/run_spark_rmhtml.sh ${PST_PREFIX}

#./bin/run_spark_sentiment.sh $LINE

spark-submit --master local[*] --driver-memory 16g --jars lib/elasticsearch-hadoop-2.2.0-m1.jar --conf spark.storage.memoryFraction=.8 spark/es_simple_ingest.py "pst-extract/spark-emails-sentiment/${LINE}/part-*" "${ES_INDEX}/phase1" --id_field id

done < "$FILE"

END=$(date +%s)
DIFF=$(( $END - $START ))
echo "It took $DIFF seconds"
