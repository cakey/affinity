request = require 'supertest'
affinity = require '../affinity'
expect = require('chai').expect
affinity_api = require('./api').app

describe 'Given a schema with a single one hop relationship(attending) between two nodes ,', ->
    entities = 
        nodes: 
            user: {}
            event: {}
        edges:
            attending: {
                    actor: 'user',
                    subject: 'event'
            }

    app = affinity.create entities
    api = affinity_api app
    
    describe 'given a fresh actor and subject', ->
        describe 'POSTing a correct edge', ->
            it 'should return a list with that edge', (done) ->
                api.node.create "user", {}, (user_id) ->
                    api.node.create "event", {}, (event_id) ->
                        api.edge.create "attending", user_id, event_id, ->
                            request(app)
                                .get("/user/#{user_id}/attending")
                                .end (err, res) ->
                                    expect(res.body).to.include.keys "data"
                                    expect(res.body.data)
                                        .to.be.an('array')
                                        .that.deep.equals [event_id]
                                    done()

        describe 'POSTing an incorrect edge (wrong node types)', ->
            it 'should 400', (done) ->
                api.node.create "user", {}, (user_id) ->
                    request(app)
                        .post("/user/#{user_id}/attending")
                         # ie trying to say a user attends a user
                         # when the schema specifies it has to be an event 
                        .send(id:user_id)
                        .expect(400, done)