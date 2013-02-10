expand_edge = (edge_type, _schema) -> # urgh
    if 'chain' of _schema.edges[edge_type]
        edges = []
        for element in _schema.edges[edge_type].chain
            for sub_ele in expand_edge(element, _schema) # replace with extend
                edges.push(sub_ele)
        return edges
    else
        return [edge_type]

exports.expand_edge = expand_edge
