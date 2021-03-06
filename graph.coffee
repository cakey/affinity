uuid = require "node-uuid"
exports.memory = ->
    nodes = {}
    edges = {}
    
    node_type = (id) ->
        if nodes[id]?
            return nodes[id].node_type
        else
            return null

    create_node = (node_type, properties) ->
        new_id = uuid.v4()
        
        if not properties?
            properties = {id: new_id}
        else
            properties.id = new_id
        nodes[new_id] = {node_type: node_type, properties:properties}

        
        return properties
        
    get_node = (id) ->
        if nodes[id]?
            return nodes[id].properties
        else
            return null
    
    delete_node = (id) ->
        # TODO: cascading with edges
        if id of nodes
            delete nodes[id]
            return true
        else
            return false
            
    update_node = (id, properties, node_type) ->
        # we pass node_type through, otherwise we may nd up with a mis match
        #  between the type of the node, and the type of the schema of the 
        #  properties that we validated
        if nodes[id]?
            if node_type is nodes[id].node_type
                nodes[id].properties = properties
                return properties
        return null
            
    # traverse uses an edge_list, while get_edges uses a single edge_type

    traverse = (id, edge_list) ->
        current_nodes = [id]
        for edge in edge_list
            next_nodes = []
            for node_id in current_nodes
                new_nodes = get_edges(node_id, edge)
                if new_nodes is null # error propogation (#fix)
                    return null
                for new_node in new_nodes # learn to extend
                    next_nodes.push(new_node)
            current_nodes = next_nodes
        return current_nodes

    get_edges = (id, edge_type) ->
        if get_node(id)?
            if edges[id]?
                if edges[id][edge_type]?
                    return edges[id][edge_type]
            return []
        return null
    
    create_edge = (actor, edge_type, subject) ->
        if get_node(actor)?
            if get_node(subject)?
                if not edges[actor]?
                    edges[actor] = {}
                if not edges[actor][edge_type]?
                    edges[actor][edge_type] = []
                    
                edges[actor][edge_type].push subject
                return edges[actor][edge_type]
        return null
        
    delete_edge = (actor, edge_type, subject) ->
        
        if get_node(actor)?
            if get_node(subject)?
                if edges[actor]?
                    if edges[actor][edge_type]?
                        if subject in edges[actor][edge_type]
                            edges[actor][edge_type] = edges[actor][edge_type].filter (word) -> word isnt subject
                            return true
        return false
        
    return {
        node_type: node_type,

        create_node: create_node,
        get_node: get_node,
        delete_node: delete_node,
        update_node: update_node,
        
        get_edges: get_edges,
        create_edge: create_edge,
        delete_edge: delete_edge,

        traverse: traverse
    }
