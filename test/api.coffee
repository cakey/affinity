request = require 'supertest'
expect = require('chai').expect

App = (app) ->
    return {
        node:
            create: (type, body, callback) ->
                request(app)
                    .post("/#{type}")
                    .send(body)
                    .end (err, res) ->
                    
                        id = res.body.data.id
                        callback(id)

            ,update: (type, id, body, callback) ->
                request(app)
                    .put("/#{type}/#{id}")
                    .send(body)
                    .end (err, res) ->
                        callback()
                       
            ,delete: (type, id, callback) ->
                request(app)
                    .del("/#{type}/#{id}")
                    .end (err, res) ->
                        callback()
        edge:
            create: (edge_type, actor_id, subject_id, callback) ->
                request(app)
                    .post("/node/#{actor_id}/#{edge_type}")
                    .send(id:subject_id) 
                    .end (err, res) ->
                        callback()
    }
 
        
exports.app = App