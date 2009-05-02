{
	"typedefs": {
		"mystr" : {
			"type": "string",
			"range": [0,2],
			"myattr":"1"
		}
	},

	"config" : {
		"FOO" : "Bar",
		"A" : "B"
	},

	"classes": {
		"Foo" : {
			"pk"   : [
				["Foo" , "id"],
				["Bar", "foo"]
			],
			"indexes" : [
				[["Foo" , "b"]],
				[
					["Foo" , "id"],
					["Foo" , "foo"]
				]
			],
			"members" : {
				"id" : {
					"type" : "uint",
					"autoincrement" : 1
				},
				"b" : {
					"type" : "int"
				},
				"name" : {
					"type" : "string",
					"range" : [0, 5]
				},
				"foo" : {
					"type" : "mystr"
				},
				"c" : {
					"type" : "mystr",
					"myattr" :"2",
					"default": "hello world"
				}
			},
			"dbfunctions" : {
				"foo" : {
					"args" : [
						["Foo" , "id"]
					],
					"return" : [
						["Foo" , "name"]
					]
				}
			}
		}
	}
}
