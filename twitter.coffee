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
        follows: 
            actor: "user",
            subject: "user"
        
        tweeted: 
            actor: "user",
            subject: "tweet"
       
        
affinity.serve entities