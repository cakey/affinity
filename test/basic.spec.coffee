request = require 'supertest'
affinity = require '../affinity'


describe 'twitter api', ->
    entities = {
        "nodes": {
            "user": {
                "name": {
                    "type": "string"
                }
            },
        },
    }
    app = affinity.create entities
    
    describe 'GET /', ->
        it 'should return the affinity spec', (done) ->
            request(app)
                .get("/")
                .expect(200, entities, done)