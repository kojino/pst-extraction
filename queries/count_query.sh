curl -XGET -H "Content-Type:application/json" http://10.31.9.77:9200/_count -d '
{
    "query": {
        "match_all": {}
    }
}
'