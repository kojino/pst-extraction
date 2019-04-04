from pyspark import SparkContext, SparkConf
from elasticsearch import Elasticsearch

import json
import argparse

def index_partition(doc_iter, nodes, index, type, id_field=None):
    print ("Connecting to ES on:"+str(nodes))
    print ("Updating index:"+index+"/"+type+" id_field="+str(id_field))
    es=Elasticsearch(nodes)
    for doc in doc_iter:
        if not id_field:
            es.index(index=index, doc_type=type, body=json.dumps(doc))
        else:
            es.index(index=index, doc_type=type, body=json.dumps(doc), id=doc[id_field])


def dump(x):
    return json.dumps(x)

if __name__ == "__main__":

    desc='elastic search ingest'
    parser = argparse.ArgumentParser(
        description=desc,
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=desc)

    parser.add_argument("input_path", help="lines of json to ingest")
    parser.add_argument("es_resource", help="index and doc_type (my-index/doc)")
    parser.add_argument("--id_field", help="id field to map into es")
    parser.add_argument("--es_nodes", default="holy-es-dev01,holy-es-dev02,holy-es-dev03,holy-es-dev04,holy-es-dev05,holy-es-dev06,holy-es-dev07,holy-es-dev08", help="es.nodes")

    args = parser.parse_args()

    nodes=[{"host":str(node), "port":9200} for node in args.es_nodes.split(',')]

    print ("NODES:"+str(nodes))

    conf = SparkConf().setAppName("Elastic Ingest")
    sc = SparkContext(conf=conf)

    index=args.es_resource.split("/")[0]
    type=args.es_resource.split("/")[1]
    id_field=args.id_field

    rdd_emails = sc.textFile(args.input_path).coalesce(50).map(lambda x: json.loads(x))
    rdd_emails.foreachPartition(lambda docs: index_partition(docs, nodes, index, type, id_field))
