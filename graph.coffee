uuid = require "node-uuid"
exports.memory = () ->
    nodes = {}
    
    create_node = (node_type) ->
        new_id = uuid.v4()
        nodes[new_id] = {node_type: node_type}
        return {id: new_id}
        
    get_node = (id) ->
        return nodes[id]
    
    delete_node = (id) ->
        if id of nodes
            delete nodes[id]
            return true
        else
            return false
        
    return {
        create_node: create_node,
        get_node: get_node,
        delete_node: delete_node
    }
