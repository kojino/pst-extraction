from bs4 import BeautifulSoup
import unicodedata
import html


def split(txt, seps):
    default_sep = seps[0]

    # we skip seps[0] because that's the default seperator
    for sep in seps[1:]:
        txt = txt.replace(sep, default_sep)
    return [i.strip() for i in txt.split(default_sep)]


def remove_html(raw):
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
    return text


if __name__ == "__main__":

    desc = 'remove html tags from email text'
    parser = argparse.ArgumentParser(
        description=desc,
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=desc)
    parser.add_argument("input_path_emails", help="directory with json emails")
    parser.add_argument(
        "output_path_email_address",
        help="output directory for spark results of json email address ")

    lex_date = datetime.datetime.utcnow().strftime('%Y%m%d%H%M%S')
    print "Running with json filter {}.".format("enabled" if args.
                                                validate_json else "disabled")
    # filter_fn = partial(valid_json_filter, os.path.basename(__file__),
    #                     lex_date, not args.validate_json)

    # conf = SparkConf().setAppName("Html Tag Removal")
    # sc = SparkContext(conf=conf)
    # rdd_raw_emails = sc.textFile(args.input_path_emails).cache()
    # rdd_text = rdd_raw_emails.filter(filter_fn).flatMap(remove_html).cache()
    # #rdd_addr_to_emails.saveAsTextFile(args.output_path_email_address)