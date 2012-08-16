http = require 'http'

entities = 
    nodes:
        user:
            name:
                type: "string"
        tweet:
            content:
                type: "string"
    edges:
        follows: [
            "user",
            "user"
        ]
        tweeted: [
            "user",
            "tweet"
        ]
        followed_tweets: [
            "follows",
            "tweeted"
        ]
                     
server = http.createServer (req, res) ->
    console.log req.headers
    console.log req.method
    console.log req.url
    
    headers = {"Content-Type": "application/json"}
   
    cleaned_url = req.url.split("/")[1..]
    console.log cleaned_url
    if cleaned_url[0] of entities.nodes
        id = cleaned_url[1]
        if cleaned_url[2] of entities.edges
            res.writeHead 200
            res.end "hit node/#{id}/edge"
        res.writeHead 200
        res.end "node"
    else
        res.writeHead 200, headers
        res.end JSON.stringify entities

server.listen 8080