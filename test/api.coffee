request = require 'supertest'
expect = require('chai').expect

# TODO: can create an api with the app, so you don't have to
#       send it as an argument every time...

create_node = (app, type, callback) ->
    request(app)
        .post("/#{type}")
        .end (err, res) ->
            id = res.body.data.id
            callback(id)

exports.node = 
    create: create_node
