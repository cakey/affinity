uuid = require "node-uuid"
exports.memory = ->
    nodes = {}
    
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
            else
                return null
        
        else
            return null
        
    return {
        create_node: create_node,
        get_node: get_node,
        delete_node: delete_node,
        update_node: update_node
    }
