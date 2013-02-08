=== Usage ===

This project creates a REST api from a simple schema.

The idea is for there to be a canonical graph-like schema that describes your data, making it much clearer to anyone involved in the project what the data looks like.

At the moment it is only useful as a rapid prototyping tool to allow you to focus your initial effort on front end concerns, but eventually the project plans to include scalable backend storage, meaning you can completely ignore backend concerns, and focus on usability.

Create a Schema file example:[todo.affinity], which is just a coffeescript object

Run using:

coffee affinity [schema] ([port])

Example:
coffee affinity todo 8080

The schema takes the form of (where []'s should be replaced with the names of your nodes and properties')

{
    "nodes": {
        "[node_type]": {
            "[node_property]": {}
            }
        },
        "[node_type]": {
            "[node_property]": {}
        }
    },
    "edges": {
        "[edge_type]": {
        	"actor": [node_type_1]
        	"subject": [node_type_2],
        },
    }
}

See twitter.affinity or twitter.coffee for more comprehensive examples.

=== Features ===
 * Can CRD nodes
 
=== Planned ===
 * type checking/validation of properties
 * Emitters
 * Custom Urls?
 * Hooks?
 * relationship chaining (arbitrary regex of relationships)
 * Variable backend storage systems
 * Possibility for it to just bootstrap itself on a cloud service, creating the necessary instances automatically.
Early stages!


=== DEV ===
Setup:
*install noode*
npm install -g coffee-script
npm install -g jasmine-node
npm install (in dir)

To run:
coffee affinity [schema] ([port])

To test:
npm test

==== Links ====
 * https://github.com/visionmedia/supertest
 * http://expressjs.com/api.html
 * https://npmjs.org/doc/scripts.html
 * http://visionmedia.github.com/mocha/