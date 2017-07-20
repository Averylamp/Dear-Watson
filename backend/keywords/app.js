var request = require("sync-request");

// TODO: params = {...?}
exports.main = function(params) {
    var url = "https://gateway.watsonplatform.net/natural-language-understanding/api/v1/analyze?version=2017-02-27";

    var auth = "Basic OThkMDQxZjktMTgyMy00ZWIwLWIyOTctMjBkYjc0NWM4ZmIzOjAwWGlzb2RhaEpNUQ=="

    var headers = {
        "Content-Type": "application/json",
        "Authorization": auth
    }

    var options = {
        headers: headers,
        json: {
            "text": "I'm really bored!",
            'features': {
                'keywords': {
                    'emotion': true,
                    'sentiment': true,
                    'limit': 10 //limit to 10 keywords.
                },
            }
        } // Change to params.text
    }

    var res = request("POST", url, options);
    if (res.statusCode >= 300) {
        return {"success": false};
    }

    // the below will prob need to change

    var list = JSON.parse(res.body.toString("utf8")).keywords

    list.sort(function(a, b) {
        if (a.relevance > b.relevance) return -1;
        if (a.relevance < b.relevance) return 1;
        return 0;
    });
        return {"success":true, "keywords":list};
}

