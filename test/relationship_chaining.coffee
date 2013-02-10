request = require 'supertest'
affinity = require '../affinity'
expect = require('chai').expect
affinity_api = require('./api').app

describe 'Given a schema with a chain,', ->
    entities = 
        nodes: 
            user: {}
            event: {}
        edges:
            attending:
                actor: 'user'
                subject: 'event'
            friend:
                actor: 'user'
                subject: 'user'
            friends_events:
                chain: ['friend', 'attending']

    app = affinity.create entities
    api = affinity_api app
    
    describe 'creating the appropriate chain', ->
        describe 'then GETting the chain of the original node', ->
            it 'should return the end node of that chain', (done) ->
                api.node.create "user", {}, (user1_id) ->
                    api.node.create "user", {}, (user2_id) ->
                        api.node.create "event", {}, (event_id) ->
                            api.edge.create "friend", user1_id, user2_id, ->
                                api.edge.create "attending", user2_id, event_id, ->
                                    request(app)
                                        .get("/user/#{user1_id}/friends_events")
                                        .end (err, res) ->
                                            expect(res.body).to.include.keys "data"
                                            expect(res.body.data)
                                                .to.be.an('array')
                                                .that.deep.equals [event_id]
                                            done()