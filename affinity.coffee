http = require 'http'
neo4j = require 'neo4j'

exports.serve = (entities) ->
    db = new neo4j.GraphDatabase 'http://localhost:7474'
                   
    callback = (err, result) ->
        console.log "callback"
        if err
            console.error err
        else
            console.log result
                    
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
            else
                node = db.createNode({'hello': 'world'})
                node.save(callback)
            
        else
            res.writeHead 200, headers
            res.end JSON.stringify entities
        console.log "\n"

    server.listen 8080