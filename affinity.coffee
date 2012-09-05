http = require 'http'
neo4j = require 'neo4j'
express = require 'express'
fs = require 'fs'

String::endsWith = (str) -> @match(new RegExp "#{str}$")

create = (schema) ->
    app = express()
                   
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
            res.send 400, "wrong node type !"
                    
    app.param 'edge_type', (req, res, next, edge_type) ->
        console.log "checking edge type"
        if edge_type of schema.edges
            next()
        else
            res.send 400, "wrong edge type !"
                    
    app.get '/:node_type', (req, res) ->
        res.send "get all the #{req.params.node_type}s!"
        
    app.get '/:node_type/:id', (req, res) -> 
        res.send "get the #{req.params.node_type} with id #{req.params.id}!"
        
    app.get '/:node_type/:id/:edge_type', (req, res) ->
        res.send "getting the #{req.params.edge_type}s of #{req.params.node_type} ##{req.params.id}!"
        
    # the root address should return the schema
    app.get '/', (req, res) ->
        res.json schema
     
    app.all '*', (req, res) ->
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
    
    
    
    
test = () ->
    server = http.createServer (req, res) ->

        console.log req.method, req.url
        
        headers = {"Content-Type": "application/json"}
       
        cleaned_url = req.url.split("/")[1..]
        console.log cleaned_url
        node_type = cleaned_url[0]
        if node_type of entities.nodes
            id = cleaned_url[1]
            if cleaned_url[2] of entities.edges
                res.writeHead 200
                res.end "hit node/#{id}/edge"
            
            if req.method == "GET"
                if id?
                    db.getNodeById id, (err, result) ->
                        console.log err
                        if err
                            if err.code is "ECONNREFUSED"
                                res.writeHead 500
                                res.end "could not connect to db!"
                            else
                                res.writeHead 404
                                res.end "#{node_type} with id #{id} not found"
                        else
                            console.log "success?"
                            # console.log result
                            res.writeHead 200
                            res.end JSON.stringify result.data
                else
                    db.getIndexedNodes "nodes", "type", "user", callback
                    res.writeHead 200
                    res.end "all the #{node_type}s!"
            else if req.method is "POST"
                console.log req.body
                # node = db.createNode({'hello': 'world'})
                # node.save(callback)
            else
                res.writeHead 400
                res.end "dont understand that method"
            
        else
            res.writeHead 200, headers
            res.end JSON.stringify entities
        console.log "\n"
        

    server.listen 8080