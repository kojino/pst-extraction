curl -XGET -H "Content-Type:application/json" http: //10.31.9.77:9200/_search -d ' {
    "query": {
        "terms": {
            "body": [
                "MRC",
                "NRC",
                "OTC",
                "TCV",
                "ARC",
                "ACV",
                "INR",
                "Rs.",
                "Rupees",
                "USD",
                "$",
                "Lakh",
                "Lak",
                "Lac",
                "Lakhs",
                "Laks",
                "Lacs",
                "lakh",
                "lac",
                "lak",
                "Crores",
                "Crs",
                "CR",
                "Cr"
            ]
        }
    }
}'

curl -XGET -H "Content-Type:application/json" http: //10.31.9.77:9200/_search -d ' {
    "query": {
        "terms": {
            "attachments.content": [
                "MRC",
                "NRC",
                "OTC",
                "TCV",
                "ARC",
                "ACV",
                "INR",
                "Rs.",
                "Rupees",
                "USD",
                "$",
                "Lakh",
                "Lak",
                "Lac",
                "Lakhs",
                "Laks",
                "Lacs",
                "lakh",
                "lac",
                "lak",
                "Crores",
                "Crs",
                "CR",
                "Cr"
            ]
        }
    }
}'

curl -XGET -H "Content-Type:application/json" http: //10.31.9.77:9200/_search -d ' {
    "query": {
        "terms": {
            "attachments.filename": [
                "MRC",
                "NRC",
                "OTC",
                "TCV",
                "ARC",
                "ACV",
                "INR",
                "Rs.",
                "Rupees",
                "USD",
                "$",
                "Lakh",
                "Lak",
                "Lac",
                "Lakhs",
                "Laks",
                "Lacs",
                "lakh",
                "lac",
                "lak",
                "Crores",
                "Crs",
                "CR",
                "Cr"
            ]
        }
    }
}'