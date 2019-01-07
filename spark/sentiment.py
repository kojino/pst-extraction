from nltk.sentiment.vader import SentimentIntensityAnalyzer
import argparse
import json
from pyspark import SparkContext, SparkConf
import nltk
nltk.download('vader_lexicon')

def nltk_sentiment(doc_tuple):
    doc_id, text = doc_tuple
    analyzer = SentimentIntensityAnalyzer()
    score = analyzer.polarity_scores(text)
    return {'id':doc_id, 'compound_sentiment_score': score['compound'], 'pos_sentiment_score': score['pos'], 'neg_sentiment_score': score['neg'], 'neu_sentiment_score': score['neu'], 'body': text}


if __name__ == "__main__":

    desc = 'extract sentiment from email text'
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

    conf = SparkConf().setAppName("Sentiment Analysis")
    sc = SparkContext(conf=conf)
    rdd = sc.textFile(args.input_path)

    def doc_to_tuple(sz):
        j = json.loads(sz)
        return (j.get('id'), j.get('body'))

    sentiments = rdd.map(doc_to_tuple).map(nltk_sentiment).cache()

    output = sentiments.map(lambda x: json.dumps(x))

    output.saveAsTextFile(args.output_path)
