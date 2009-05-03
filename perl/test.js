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
				["Bar", "b"],
				["Foo", "id"],
				["Bar", "foo"]
			],
			"indexes" : [
				[["Foo" , "b"]],
				[
					["Foo", "id"],
					["Bar", "foo"],
					["Foo", "foo"]
				],
				[["Bar", "b"]]
			],
			"members" : [
				["id", {
					"type" : "uint",
					"auto_increment" : 1
				}],
				["b", {
					"type" : "int"
				}],
				["name", {
					"type" : "string",
					"range" : [0, 5]
				}],
				["foo", {
					"type" : "mystr"
				}],
				["c", {
					"type" : "mystr",
					"myattr" :"2",
					"default": "hello world"
				}]
			],
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
