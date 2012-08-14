# Requires
queryEngine = require?(__dirname+'/../lib/query-engine.js') or @queryEngine
assert = require?('assert') or @assert
Backbone = require?('backbone') or @Backbone
joe = require?('joe') or @joe
{describe} = joe


# =====================================
# Configuration

# -------------------------------------
# Variables

today = new Date()
today.setHours 0
today.setMinutes 0
today.setSeconds 0
tomorrow = new Date()
tomorrow.setDate(today.getDate()+1)
yesterday = new Date()
yesterday.setDate(today.getDate()-1)


# -------------------------------------
# Data

# Store
modelsObject =
	'index':
		id: 'index'
		title: 'Index Page'
		content: 'this is the index page'
		tags: []
		position: 1
		positionNullable: null
		category: 1
		date: today
		good: true
		obj: {a:1,b:2}
	'jquery':
		id: 'jquery'
		title: 'jQuery'
		content: 'this is about jQuery'
		tags: ['jquery']
		position: 2
		positionNullable: 2
		category: 1
		date: yesterday
		good: false
	'history':
		id: 'history'
		title: 'History.js'
		content: 'this is about History.js'
		tags: ['jquery','html5','history']
		position: 3
		positionNullable: 3
		category: 1
		date: tomorrow

store =
	associatedStandard: queryEngine.createCollection(modelsObject)
	associatedModels: queryEngine.createCollection(
		'index': new Backbone.Model(modelsObject.index)
		'jquery': new Backbone.Model(modelsObject.jquery)
		'history': new Backbone.Model(modelsObject.history)
	)


# =====================================
# Tests

# Generate Test Suite
generateTestSuite = (describe, it, name,docs) ->
	describe name, (describe,it) ->
		it 'beginsWith', ->
			actual = docs.findAll title: $beginsWith: 'Index'
			expected = queryEngine.createCollection 'index': docs.get('index')
			assert.deepEqual actual.toJSON(), expected.toJSON()

		it 'endsWidth', ->
			actual = docs.findAll title: $endsWith: '.js'
			expected = queryEngine.createCollection 'history': docs.get('history')
			assert.deepEqual actual.toJSON(), expected.toJSON()

		it 'string', ->
			actual = docs.findAll id: 'index'
			expected = queryEngine.createCollection 'index': docs.get('index')
			assert.deepEqual actual.toJSON(), expected.toJSON()

		it 'number', ->
			actual = docs.findAll position: 3
			expected = queryEngine.createCollection 'history': docs.get('history')
			assert.deepEqual actual.toJSON(), expected.toJSON()

		it 'date', ->
			actual = docs.findAll date: today
			expected = queryEngine.createCollection 'index': docs.get('index')
			assert.deepEqual actual.toJSON(), expected.toJSON()

		it 'regex', ->
			actual = docs.findAll id: /^[hj]/
			expected = queryEngine.createCollection 'jquery': docs.get('jquery'), 'history': docs.get('history')
			assert.deepEqual actual.toJSON(), expected.toJSON()

		it 'joint', ->
			actual = docs.findAll id: 'index', category: 1
			expected = queryEngine.createCollection 'index': docs.get('index')
			assert.deepEqual actual.toJSON(), expected.toJSON()

		it 'boolean-true', ->
			actual = docs.findAll good: true
			expected = queryEngine.createCollection 'index': docs.get('index')
			assert.deepEqual actual.toJSON(), expected.toJSON()

		it 'boolean-false', ->
			actual = docs.findAll good: false
			expected = queryEngine.createCollection 'jquery': docs.get('jquery')
			assert.deepEqual actual.toJSON(), expected.toJSON()

		it '$and', ->
			actual = docs.findAll $and: [{id: 'index'}, {position: 1}]
			expected = queryEngine.createCollection 'index': docs.get('index')
			assert.deepEqual actual.toJSON(), expected.toJSON()

		it '$and-none', ->
			actual = docs.findAll $and: [{random:Math.random()}]
			expected = queryEngine.createCollection()
			assert.deepEqual actual.toJSON(), expected.toJSON()

		it '$not', ->
			actual = docs.findAll $not: [{id: 'index'}, {position: 1}]
			expected = queryEngine.createCollection 'jquery': docs.get('jquery'), 'history': docs.get('history')
			assert.deepEqual actual.toJSON(), expected.toJSON()

		it '$or', ->
			actual = docs.findAll $or: [{id: 'index'}, {position: 2}]
			expected = queryEngine.createCollection 'index': docs.get('index'), 'jquery': docs.get('jquery')
			assert.deepEqual actual.toJSON(), expected.toJSON()

		it '$or-object', ->
			actual = docs.findAll $or: {id: 'index', position: 2}
			expected = queryEngine.createCollection 'index': docs.get('index'), 'jquery': docs.get('jquery')
			assert.deepEqual actual.toJSON(), expected.toJSON()

		it '$or-none', ->
			actual = docs.findAll $or: [{random:Math.random()}]
			expected = queryEngine.createCollection()
			assert.deepEqual actual.toJSON(), expected.toJSON()

		it '$nor', ->
			actual = docs.findAll $nor: [{id: 'index'}, {position: 2}]
			expected = queryEngine.createCollection 'history': docs.get('history')
			assert.deepEqual actual.toJSON(), expected.toJSON()

		it '$nor-none', ->
			actual = docs.findAll $nor: [{random:Math.random()}]
			expected = docs
			assert.deepEqual actual.toJSON(), expected.toJSON()

		it '$ne', ->
			actual = docs.findAll id: $ne: 'index'
			expected = queryEngine.createCollection 'jquery': docs.get('jquery'), 'history': docs.get('history')
			assert.deepEqual actual.toJSON(), expected.toJSON()

		it '$all', ->
			actual = docs.findAll tags: $all: ['jquery']
			expected = queryEngine.createCollection 'jquery': docs.get('jquery')
			assert.deepEqual actual.toJSON(), expected.toJSON()

		it '$in', ->
			actual = docs.findAll tags: $in: ['jquery']
			expected = queryEngine.createCollection 'jquery': docs.get('jquery'), 'history': docs.get('history')
			assert.deepEqual actual.toJSON(), expected.toJSON()

		it '$nin', ->
			actual = docs.findAll tags: $nin: ['history']
			expected = queryEngine.createCollection 'index': docs.get('index'), 'jquery': docs.get('jquery')
			assert.deepEqual actual.toJSON(), expected.toJSON()

		it '$size', ->
			actual = docs.findAll tags: $size: 3
			expected = queryEngine.createCollection 'history': docs.get('history')
			assert.deepEqual actual.toJSON(), expected.toJSON()

		it '$like', ->
			actual = docs.findAll content: $like: 'INDEX'
			expected = queryEngine.createCollection 'index': docs.get('index')
			assert.deepEqual actual.toJSON(), expected.toJSON()

		it '$likeSensitive', ->
			actual = docs.findAll content: $likeSensitive: 'INDEX'
			expected = queryEngine.createCollection()
			assert.deepEqual actual.toJSON(), expected.toJSON()

			actual = docs.findAll content: $likeSensitive: 'index'
			expected = queryEngine.createCollection 'index': docs.get('index')
			assert.deepEqual actual.toJSON(), expected.toJSON()

		it '$mod', ->
			actual = docs.findAll position: $mod: [2,0]
			expected = queryEngine.createCollection 'jquery': docs.get('jquery')
			assert.deepEqual actual.toJSON(), expected.toJSON()

		it '$eq', ->
			actual = docs.findAll obj: $eq: {a:1,b:2}
			expected = queryEngine.createCollection 'index': docs.get('index')
			assert.deepEqual actual.toJSON(), expected.toJSON()

		it '$bt', ->
			actual = docs.findAll position: $bt: [1,3]
			expected = queryEngine.createCollection 'jquery': docs.get('jquery')
			assert.deepEqual actual.toJSON(), expected.toJSON()

		it '$bte', ->
			actual = docs.findAll position: $bte: [2,3]
			expected = queryEngine.createCollection 'jquery': docs.get('jquery'), 'history': docs.get('history')
			assert.deepEqual actual.toJSON(), expected.toJSON()

		it '$gt', ->
			actual = docs.findAll position: $gt: 2
			expected = queryEngine.createCollection 'history': docs.get('history')
			assert.deepEqual actual.toJSON(), expected.toJSON()

		it '$gt-date', ->
			actual = docs.findAll date: $gt: today
			expected = queryEngine.createCollection 'history': docs.get('history')
			assert.deepEqual actual.toJSON(), expected.toJSON()

		it '$gte', ->
			actual = docs.findAll position: $gte: 2
			expected = queryEngine.createCollection 'jquery': docs.get('jquery'), 'history': docs.get('history')
			assert.deepEqual actual.toJSON(), expected.toJSON()

		it '$lt', ->
			actual = docs.findAll position: $lt: 2
			expected = queryEngine.createCollection 'index': docs.get('index')
			assert.deepEqual actual.toJSON(), expected.toJSON()

		it '$lt-date', ->
			actual = docs.findAll date: $lt: today
			expected = queryEngine.createCollection 'jquery': docs.get('jquery')
			assert.deepEqual actual.toJSON(), expected.toJSON()

		it '$lte', ->
			actual = docs.findAll position: $lte: 2
			expected = queryEngine.createCollection 'index': docs.get('index'), 'jquery': docs.get('jquery')
			assert.deepEqual actual.toJSON(), expected.toJSON()

		it '$lte-date', ->
			actual = docs.findAll date: $lte: today
			expected = queryEngine.createCollection 'index': docs.get('index'), 'jquery': docs.get('jquery')
			assert.deepEqual actual.toJSON(), expected.toJSON()
			
		it '$has-false', ->
			actual = docs.findAll good: $has: false
			expected = queryEngine.createCollection 'jquery': docs.get('jquery')
			assert.deepEqual actual.toJSON(), expected.toJSON()
		
		it 'all', ->
			actual = docs
			expected = docs
			assert.deepEqual actual.toJSON(), expected.toJSON()

		it 'findOne', ->
			actual = docs.findOne(tags: $has: 'jquery')
			expected = docs.get('jquery')
			assert.deepEqual actual.toJSON(), expected.toJSON()


		describe 'nullable', (describe,it) ->

			it "null values should show up when searching for them", ->
				actual = docs.findAll(positionNullable: null)
				expected = queryEngine.createCollection('index': docs.get('index'))
				assert.deepEqual actual.toJSON(), expected.toJSON()

			it "null values shouldn't show up in greater than or equal to comparisons", ->
				actual = docs.findAll(positionNullable: $gte: 0)
				expected = queryEngine.createCollection 'jquery': docs.get('jquery'), 'history': docs.get('history')
				assert.deepEqual actual.toJSON(), expected.toJSON()

			it "null values shouldn't show up in less than comparisons", ->
				actual = docs.findAll(positionNullable: $lte: 3)
				expected = queryEngine.createCollection 'jquery': docs.get('jquery'), 'history': docs.get('history')
				assert.deepEqual actual.toJSON(), expected.toJSON()


		describe 'paging', (describe,it) ->

			it 'limit', ->
				actual = docs.createChildCollection().query({limit:1})
				expected = queryEngine.createCollection 'index': docs.get('index')
				assert.deepEqual actual.toJSON(), expected.toJSON()

			it 'limit+page', ->
				actual = docs.createChildCollection().query({limit:1,page:2})
				expected = queryEngine.createCollection 'jquery': docs.get('jquery')
				assert.deepEqual actual.toJSON(), expected.toJSON()

			it 'limit+offset', ->
				actual = docs.createChildCollection().query({limit:1,offset:1})
				expected = queryEngine.createCollection 'jquery': docs.get('jquery')
				assert.deepEqual actual.toJSON(), expected.toJSON()

			it 'limit+offset+page', ->
				actual = docs.createChildCollection().query({limit:1,offset:1,page:2})
				expected = queryEngine.createCollection 'history': docs.get('history')
				assert.deepEqual actual.toJSON(), expected.toJSON()

			it 'limit+offset+page (via findAll)', ->
				actual = docs.findAll({id: $exists: true}, null, {limit:1,offset:1,page:2})
				expected = queryEngine.createCollection 'history': docs.get('history')
				assert.deepEqual actual.toJSON(), expected.toJSON()

			it 'offset', ->
				actual = docs.createChildCollection().query({offset:1})
				expected = queryEngine.createCollection 'jquery': docs.get('jquery'), 'history': docs.get('history')
				assert.deepEqual actual.toJSON(), expected.toJSON()

# Generate Suites
describe 'queries', (describe,it) ->
	for own key, value of store
		generateTestSuite describe, it, key, value

# Return
null