affinity = require './affinity.coffee'

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
        
        
affinity.serve entities