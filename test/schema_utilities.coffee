expect = require('chai').expect
schema_util = require('../schema_util')

describe 'Given a schema, ', ->
    entities = 
        nodes: 
            user: {}
            event: {}
        edges:
            attending:
                actor: 'user'
                subject: 'event'
            friend:
                actor: 'user'
                subject: 'user'
            friends_events:
                chain: ['friend', 'attending']
            friends_friends_events:
                chain: ['friend', 'friends_events']
    
    describe 'expanding an atomic edge, ', ->
        it 'should return a list with just that edge', (done) ->
            edge_list = schema_util.expand_edge('attending', entities)
            expect(edge_list)
                .to.be.an('array')
                .that.deep.equals ['attending']
            done()

    describe 'expanding a 1 level chain edge, ', ->
        it 'should return a list with each intermediate edge', (done) ->
            edge_list = schema_util.expand_edge('friends_events', entities)
            expect(edge_list)
                .to.be.an('array')
                .that.deep.equals ['friend', 'attending']
            done()

    describe 'expanding a 2 level chain edge, ', ->
        it 'should return a list with each intermediate edge', (done) ->
            edge_list = schema_util.expand_edge('friends_friends_events', entities)
            expect(edge_list)
                .to.be.an('array')
                .that.deep.equals ['friend', 'friend', 'attending']
            done()