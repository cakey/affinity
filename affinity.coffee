http = require 'http'
neo4j = require 'neo4j'
express = require 'express'
fs = require 'fs'
database = require('./graph').memory

String::endsWith = (str) -> @match(new RegExp "#{str}$")

create = (schema) ->
    app = express()
    graph = database()
                   
    callback = (err, result) ->
        console.log "callback"
        if err
            console.error err
        else
            console.log result
                    
    app.param 'node_type', (req, res, next, node_type) ->
        console.log "checking node type"
        if node_type of schema.nodes
            next()
        else
            res.json 400, {"error":"non existent node type"}
                    
    app.param 'edge_type', (req, res, next, edge_type) ->
        console.log "checking edge type"
        if edge_type of schema.edges
            next()
        else
            res.send 400, "wrong edge type !"
                    
    app.get '/:node_type', (req, res) ->
        res.send "get all the #{req.params.node_type}s!"
        
    app.post '/:node_type', (req, res) ->
        node = graph.create_node req.params.node_type
        res.json {data: node}
        
    app.get '/:node_type/:id', (req, res) -> 
        console.log "get the #{req.params.node_type} with id #{req.params.id}!"
        node = graph.get_node req.params.id
        if node?
            res.json {data: node}
        else
            res.json 404, {error: "#{req.params.node_type} with id #{req.params.id} was not found"}
    
    app.delete '/:node_type/:id', (req, res) ->
        deleted = graph.delete_node req.params.id
        if deleted
            res.json 204, {data: {} }
        else 
            res.json 404, {error: "#{req.params.node_type} with id #{req.params.id} was not found"}
    
    app.get '/:node_type/:id/:edge_type', (req, res) ->
        res.send "getting the #{req.params.edge_type}s of #{req.params.node_type} ##{req.params.id}!"
        
    # the root address should return the schema
    app.get '/', (req, res) ->
        res.json schema
     
    app.all '*', (req, res) ->
        console.log "didnt match #{req.url}"
        res.send 400, "didnt match #{req.url}"
    
    return app
    
serve = (schema, port) ->
    app = create schema
    if not port?
        port = 3000
    console.log "starting on port #{port}!"
    db = new neo4j.GraphDatabase 'http://localhost:7474'
    app.listen port
    
if not module.parent
    affinity_spec_file = process.argv[2]
    if not affinity_spec_file.endsWith ".affinity"
        affinity_spec_file += ".affinity"
    fileContents = fs.readFileSync affinity_spec_file, 'utf8'
    schema = JSON.parse fileContents 
    port = process.argv[3]
    serve schema, port
else
    exports.create = create
    exports.serve = serve