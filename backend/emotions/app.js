var request = require("sync-request");

// params = {"text": "..."}
exports.main = function(params) {
    var url = "https://gateway.watsonplatform.net/tone-analyzer/api/v3/tone?version=2016-05-19";

    var auth = "Basic ZmZiNWFiOWYtYWMzZi00ZDQ0LWFhYmEtMTlmNzAwZGZmZWQ2Ok9QUjNUSWIyc1Fjdg==";

    var headers = {
        "Content-Type": "application/json",
        "Authorization": auth
    }

    var options = {
        headers: headers,
        json: { "text": params.text}
    }

    var res = request("POST", url, options);

    if (res.statusCode >= 300) {
        return {"success": false};
    }

    var list = JSON.parse(res.body.toString("utf8")).document_tone.tone_categories[0].tones;

    list.sort(function(a, b) {
        if (a.score > b.score) return -1;
        if (a.score < b.score) return 1;
        return 0;
    })

    return {"success":true, "emotions":list};
}

