request = require 'supertest'
affinity = require '../affinity'
expect = require('chai').expect


describe 'Given a one node schema,', ->
    entities = 
        "nodes": 
            "user": {}

    app = affinity.create entities
    
    describe 'GETing /', ->
        it 'should return the affinity spec.', (done) ->
            request(app)
                .get("/")
                .expect(200, entities, done)
                
    describe 'GETing /node_not_in_schema', ->
        it 'should fail gracefully, with key error.', (done) ->
            request(app)
                .get("/node_not_in_schema")
                .end (err, res) ->
                    expect(res.status).to.equal 400
                    expect(res.body).to.include.keys "error"
                    done()
                    
    describe 'GETting a non existent node, with a type in the schema,', ->
        it 'should fail gracefully.', (done) ->
            request(app)
                .get("/user/not_a_real_user")
                .end (err, res) ->
                    expect(res.status).to.equal 404
                    expect(res.body).to.include.keys "error"
                    done()
                    
    describe 'POSTing a node in that schema,', ->
        it "should succeed and return it's id.", (done) ->
            request(app)
                .post("/user")
                .end (err, res) ->
                    expect(res.status).to.equal 200
                    expect(res.body).to.include.keys "data"
                    expect(res.body.data).to.include.keys "id"
                    done()
                    
    describe 'GETting a POSTed node,', ->
        it 'should succeed', (done) ->
            request(app)
                .post("/user")
                .end (err, res) ->
                    id = res.body.data.id
                    request(app)
                        .get("/user/#{id}")
                        .expect(200, done)                        
                    
    describe 'DELETEing a node,', ->
        it 'should work', (done) ->
            request(app)
                .post("/user")
                .end (err, res) ->
                    id = res.body.data.id
                    request(app)
                        .del("/user/#{id}")
                        .end (err, res) ->  
                            request(app)
                                .get("/user/#{id}")
                                .expect(404, done)      
        