import argparse
import json

import numpy as np
import tensorflow as tf

from functools import partial
import tensorflow_hub as hub
from pyspark import SparkConf, SparkContext


def sentence_embedding(sess, doc_tuple):
    doc_id, text = doc_tuple
    paragraph = (text)
    messages = [paragraph]
    # Reduce logging output.
    message_embedding = sess.run(embed([paragraph]))[0, :].tolist()

    return {'id': doc_id, 'body': text, 'embedding': message_embedding}


if __name__ == "__main__":

    desc = 'embed email text'
    parser = argparse.ArgumentParser(
        description=desc,
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=desc)
    parser.add_argument("-i", "--input_path", help="directory with json texts")
    parser.add_argument(
        "-o",
        "--output_path",
        help=
        "output directory for spark results of json texts with html tags removed"
    )
    args = parser.parse_args()

    conf = SparkConf().setAppName("Document Embedding")
    sc = SparkContext(conf=conf)
    rdd = sc.textFile(args.input_path)

    def doc_to_tuple(sz):
        j = json.loads(sz)
        return (j.get('id'), j.get('body'))

    module_url = "https://tfhub.dev/google/universal-sentence-encoder/2"  #@param ["https://tfhub.dev/google/universal-sentence-encoder/2", "https://tfhub.dev/google/universal-sentence-encoder-large/3"]
    # Import the Universal Sentence Encoder's TF Hub module
    embed = hub.Module(module_url)
    tf.logging.set_verbosity(tf.logging.ERROR)
    sess = tf.Session()
    sess.run([tf.global_variables_initializer(), tf.tables_initializer()])

    sentence_embedding_partial = partial(sentence_embedding, sess)
    embeddings = rdd.map(doc_to_tuple).map(sentence_embedding_partial).cache()

    output = embeddings.map(lambda x: json.dumps(x))

    output.saveAsTextFile(args.output_path)
