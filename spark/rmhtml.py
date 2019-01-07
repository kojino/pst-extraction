from bs4 import BeautifulSoup
import unicodedata
import html
from pyspark import SparkContext, SparkConf
import argparse
import json

closings = [
    "Regards,",
    "Best,",
    "Thanks,",
    "Sent from my iPhone",
    "Sent from my ipad",
    "Sent from my android",
    "Sent from my mobile device",
    "Sincerely,",
    "Regards,",
    "Yours truly,",
    "Yours sincerely,",
    "Best regards,",
    "Cordially,",
    "Yours respectfully",
    "Warm regards,",
    "Best wishes,",
    "With appreciation,",
    "Cordially yours,",
    "Fond regards,",
    "In appreciation,",
    "In sympathy,",
    "Kind regards,",
    "Kind thanks,",
    "Kind wishes,",
    "Many thanks,",
    "Regards,",
    "Respectfully,",
    "Respectfully yours,",
    "Sincerely,",
    "Sincerely yours,",
    "Warm regards,",
    "Warm wishes,",
    "Warmly,",
    "With appreciation,",
    "With deepest sympathy,",
    "With gratitude,",
    "With sincere thanks,",
    "With sympathy,",
    "Your help is greatly appreciated,",
    "Yours cordially,",
    "Yours faithfully,",
    "Yours sincerely,",
    "Yours truly,",
]


def split(txt, seps):
    default_sep = seps[0]

    # we skip seps[0] because that's the default seperator
    for sep in seps[1:]:
        txt = txt.replace(sep, default_sep)
    return [i.strip() for i in txt.split(default_sep)]


def remove_html(doc_tuple):
    doc_id, raw = doc_tuple
    soup = BeautifulSoup(
        raw, 'lxml')  # create a new bs4 object from the html data loaded
    for script in soup(["script",
                        "style"]):  # remove all javascript and stylesheet code
        script.extract()
    # get text
    text = soup.get_text()
    # break into lines and remove leading and trailing space on each
    lines = (line.strip() for line in text.splitlines())
    # break multi-headlines into a line each
    chunks = (phrase.strip() for line in lines for phrase in line.split("  "))
    # encode unicode characters
    text = unicodedata.normalize("NFKD", text)
    # encode html characters
    text = html.unescape(text)
    text = split(text, closings)[0]
    return {'id': doc_id, 'body': text}


if __name__ == "__main__":

    desc = 'remove html tags from email text'
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
    conf = SparkConf().setAppName("Html Tag Removal")
    sc = SparkContext(conf=conf)
    rdd = sc.textFile(args.input_path)

    def doc_to_tuple(sz):
        j = json.loads(sz)
        return (j.get('id'), j.get('body'))

    cleandoc = rdd.map(doc_to_tuple).map(remove_html).cache()

    output = cleandoc.map(lambda x: json.dumps(x))

    output.saveAsTextFile(args.output_path)
