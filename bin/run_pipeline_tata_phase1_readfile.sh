#!/usr/bin/env bash

set +x
set -e
echo "===========================================$0 $@"

START=$(date +%s)

FILE=$1

source conf/env.cfg

while read -r LINE; do

echo "Processing >>>>>>>>" $LINE

#./bin/run_spark_tika_scala.sh ${PST_PREFIX}

#./bin/run_binary_extraction_merge.sh ${PST_PREFIX}

#./bin/run_spark_content_split.sh  ${PST_PREFIX}

#./bin/run_spark_rmhtml.sh ${PST_PREFIX}

#./bin/run_spark_sentiment.sh $LINE

#spark-submit --master local[*] --driver-memory 16g --jars lib/elasticsearch-hadoop-2.2.0-m1.jar --conf spark.storage.memoryFraction=.8 spark/es_simple_ingest.py "pst-extract/spark-emailaddr/${LINE}/part-*" "${ES_INDEX}/${ES_DOC_TYPE_EMAILADDR}" --id_field id --es_nodes ${ES_NODES}

#spark-submit --master local[*] --driver-memory 16g --jars lib/elasticsearch-hadoop-2.2.0-m1.jar --conf spark.storage.memoryFraction=.8 spark/es_simple_ingest.py "pst-extract/spark-emails-sentiment/${LINE}/part-*" "${ES_INDEX}/${ES_DOC_TYPE_EMAILS}" --id_field id --es_nodes ${ES_NODES}

#spark-submit --master local[*] --driver-memory 16g --jars lib/elasticsearch-hadoop-2.2.0-m1.jar --conf spark.storage.memoryFraction=.8 spark/es_simple_ingest.py "pst-extract/spark-emails-attachments/${LINE}/part-*" "${ES_INDEX}/${ES_DOC_TYPE_ATTACHMENTS}" --id_field id --es_nodes ${ES_NODES}

# Email address
#spark-submit --master local[*] --driver-memory 32g --jars lib/elasticsearch-hadoop-2.2.0-m1.jar --conf spark.storage.memoryFraction=.8 spark/es_simple_ingest.py "pst-extract/spark-emailaddr/${LINE}/part-*" "${ES_INDEX}/multiple" --es_nodes "${ES_NODES}"

#Email Text
#spark-submit --master local[*] --driver-memory 32g --jars lib/elasticsearch-hadoop-2.2.0-m1.jar --conf spark.storage.memoryFraction=.8 spark/es_simple_ingest.py "pst-extract/spark-emails-sentiment/${LINE}/part-*" "${ES_INDEX}/multiple"  --es_nodes "${ES_NODES}"

# Test Phase1
spark-submit --master local[*] --driver-memory 32g --jars lib/elasticsearch-hadoop-2.2.0-m1.jar --conf spark.storage.memoryFraction=.8 spark/es_simple_ingest.py "pst-extract/spark-emailaddr/${LINE}/part-*" "tata/${ES_DOC_TYPE_EMAILADDR}" --id_field ingest_id --es_nodes ${ES_NODES}
spark-submit --master local[*] --driver-memory 32g --jars lib/elasticsearch-hadoop-2.2.0-m1.jar --conf spark.storage.memoryFraction=.8 spark/es_simple_ingest.py "pst-extract/spark-emails-text/${LINE}/part-*" "tata1/${ES_DOC_TYPE_EMAILS}" --id_field id --es_nodes ${ES_NODES}
spark-submit --master local[*] --driver-memory 32g --jars lib/elasticsearch-hadoop-2.2.0-m1.jar --conf spark.storage.memoryFraction=.8 spark/es_simple_ingest.py "pst-extract/spark-emails-sentiment/${LINE}/part-*" "tata1/${ES_DOC_TYPE_EMAILS}" --id_field id --es_nodes ${ES_NODES}
spark-submit --master local[*] --driver-memory 32g --jars lib/elasticsearch-hadoop-2.2.0-m1.jar --conf spark.storage.memoryFraction=.8 spark/es_simple_ingest.py "pst-extract/spark-emails-text-rmhtml/${LINE}/part-*" "tata1/${ES_DOC_TYPE_EMAILS}" --id_field id --es_nodes ${ES_NODES}
spark-submit --master local[*] --driver-memory 32g --jars lib/elasticsearch-hadoop-2.2.0-m1.jar --conf spark.storage.memoryFraction=.8 spark/es_simple_ingest.py "pst-extract/spark-emails-attachments/${LINE}/part-*" "tata2/${ES_DOC_TYPE_ATTACHMENTS}" --id_field id --es_nodes ${ES_NODES}

done < "$FILE"

END=$(date +%s)
DIFF=$(( $END - $START ))
echo "It took $DIFF seconds"
