request = require 'supertest'
affinity = require '../affinity'
expect = require('chai').expect
affinity_api = require('./api').app


describe 'Given a one node schema with a string property,', ->
    entities = 
        nodes: 
            user:
                name:
                    type: "string"

    app = affinity.create entities
    api = affinity_api app
    
    describe 'POSTing a node without that property', ->
        it 'should be a bad request.', (done) ->
            request(app)
                .post("/user")
                .send({})
                .expect(400, done)
                
    describe 'POSTing a node', ->
        it 'should return the POSTed properties.', (done) ->
            request(app)
                .post("/user")
                .send( name: "ben" )
                .end (err, res) ->
                    expect(res.status).to.equal 200
                    expect(res.body).to.include.keys "data"
                    expect(res.body.data).to.include.keys "name"
                    expect(res.body.data.name).to.equal "ben"
                    done()
    
    describe 'GETting an existing node', ->
        it 'should return the previously POSTed properties.', (done) ->
            api.node.create "user", name: "matt", (id) ->
                request(app)
                    .get("/user/#{id}")
                    .end (err, res) ->
                        expect(res.status).to.equal 200
                        expect(res.body).to.include.keys "data"
                        expect(res.body.data).to.include.keys "name"
                        expect(res.body.data.name).to.equal "matt"
                        done()    
                            
    describe "PUTting to an existing node", ->
        it "should update the properties", (done) ->
            api.node.create "user", name: "bob", (id) ->
                api.node.update "user", id, name: "bill", ->
                    request(app)
                        .get("/user/#{id}")
                        .end (err, res) ->
                            expect(res.status).to.equal 200
                            expect(res.body).to.include.keys "data"
                            expect(res.body.data).to.include.keys "name"
                            expect(res.body.data.name).to.equal "bill"
                            done() 