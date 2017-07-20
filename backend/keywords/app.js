var request = require("sync-request");

// TODO: params = {...?}
exports.main = function(params) {
    var url = ...

    var auth = ...

    var headers = {
        "Content-Type": "application/json",
        "Authorization": auth
    }

    var options = {
        headers: headers,
        json: { "text": "I've been having a tough day today. Life is just so boring."} // Change to params.text
    }

    var res = request("POST", url, options);

    if (res.statusCode >= 300) {
        return {"success": false};
    }


    // the below will prob need to change

    var list = JSON.parse(res.body.toString("utf8")).document_tone.tone_categories[0].tones;

    list.sort(function(a, b) {
        if (a.score > b.score) return -1;
        if (a.score < b.score) return 1;
        return 0;
    })

    return {"success":true, "emotions":list};
}

