request = require 'supertest'
affinity = require '../affinity'
expect = require('chai').expect
affinity_api = require('./api').app

describe 'Given a schema with a single one hop relationship(follows) ,', ->
    entities = 
        nodes: 
            user: {}
        edges:
            follows: 
                actor: 'user',
                subject: 'user'

    app = affinity.create entities
    api = affinity_api app
    
    describe 'GETting who follows a non existent node', ->
        it 'should be a 404.', (done) ->
            request(app)
                .get("/user/23d2d/follows")
                .expect(404, done)
    
    describe 'and given a fresh node, ', ->
        describe 'GETting who follows that node with no followers', ->
            it 'should return an empty list.', (done) ->
                api.node.create "user", {}, (id) ->
                    request(app)
                        .get("/user/#{id}/follows")
                        .end (err, res) ->
                            expect(res.body.data)
                                .to.be.an('array')
                                .that.deep.equals []
                            done()
                            
        describe 'POSTting an edge to that node', ->
            it 'should return a list with that edge.', (done) ->
                api.node.create "user", {}, (id) ->
                    request(app)
                        .post("/user/#{id}/follows")
                        .send(id:id) # follow self, TODO: toggle whether this is allowed.
                        .end (err, res) ->
                            request(app)
                                .get("/user/#{id}/follows")
                                .end (err, res) ->
                                    expect(res.body.data)
                                        .to.be.an('array')
                                        .that.deep.equals [id]
                                    done()
                                    
        describe 'DELETEing an edge from a node', ->
            it 'should delete that edge!', (done) ->
                api.node.create "user", {}, (id) ->
                    request(app)
                        .post("/user/#{id}/follows")
                        .send(id:id)
                        .end (err, res) ->
                            request(app)
                                .del("/user/#{id}/follows/#{id}")
                                .end (err, res) ->
                                    request(app)
                                        .get("/user/#{id}/follows")
                                        .end (err, res) ->
                                            expect(res.body.data)
                                                .to.be.an('array')
                                                .that.deep.equals []
                                            done()
# posting the wrong kind of node is a 400