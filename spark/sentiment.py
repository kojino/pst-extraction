from nltk.sentiment.vader import SentimentIntensityAnalyzer


def nltk_sentiment(doc_tuple):
    doc_id, text = doc_tuple
    analyzer = SentimentIntensityAnalyzer()
    score = analyzer.polarity_scores(text)
    return (doc_id, score['compound'])


if __name__ == "__main__":

    desc = 'extract sentiment from email text'
    parser = argparse.ArgumentParser(
        description=desc,
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=desc)
    parser.add_argument(
        "input_path", help="directory with html removed json texts")
    parser.add_argument(
        "output_path",
        help=
        "output directory for spark results of sentiment scores (from -1 to 1)"
    )

    conf = SparkConf().setAppName("Html Tag Removal")
    sc = SparkContext(conf=conf)
    rdd = sc.textFile(args.input_path)

    def doc_to_tuple(sz):
        j = json.loads(sz)
        return (j.get('id'), j.get('body'))

    sentiments = rdd.map(doc_to_tuple).map(nltk_sentiment).cache()

    output = sentiments.map(lambda x: "{}\t{}".format(x[0], str(x[1])))

    output.saveAsTextFile(args.output_path)