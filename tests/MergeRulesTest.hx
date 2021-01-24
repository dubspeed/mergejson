package tests;

using buddy.Should;

class MergeRulesTest extends buddy.SingleSuite {
	public function new() {
		describe("Simple types", {
			it("should combine keys on different keys", {
				var r = haxe.Json.stringify(MergeJson.merge(haxe.Json.parse('{"a":3}'), haxe.Json.parse('{"b":2}')));
				r.should.be('{"a":3,"b":2}');
			});
			it("should overwrite on same keys (int)", {
				var r = haxe.Json.stringify(MergeJson.merge(haxe.Json.parse('{"a":3}'), haxe.Json.parse('{"a":2}')));
				r.should.be('{"a":2}');
			});
			it("should overwrite on same keys (bool)", {
				var r = haxe.Json.stringify(MergeJson.merge(haxe.Json.parse('{"a":false}'), haxe.Json.parse('{"a":true}')));
				r.should.be('{"a":true}');
			});
			it("should overwrite on same keys (string)", {
				var r = haxe.Json.stringify(MergeJson.merge(haxe.Json.parse('{"a":"te"}'), haxe.Json.parse('{"a":"st"}')));
				r.should.be('{"a":"st"}');
			});
		});

		describe("Arrays", {
			var a = '{"x": [1,2,3]}';
			var b = '{"x": [4,5,6]}';
			var c = '{"y": [4,5,6]}';
			var r = "";

			it("should be concatenated with same keys", {
				var merged = MergeJson.merge(haxe.Json.parse(a), haxe.Json.parse(b));
				r = haxe.Json.stringify(merged);
				r.should.be('{"x":[1,2,3,4,5,6]}');
			});

			it("should keep different keys seperate", {
				var merged = MergeJson.merge(haxe.Json.parse(a), haxe.Json.parse(c));
				r = haxe.Json.stringify(merged);
				r.should.be('{"x":[1,2,3],"y":[4,5,6]}');
			});

			it("should merge right to left", {
				var merged = MergeJson.merge(haxe.Json.parse(b), haxe.Json.parse(a));
				r = haxe.Json.stringify(merged);
				r.should.be('{"x":[4,5,6,1,2,3]}');
			});
		});

		describe("Compared to lodash merge and mergeWith, ", {
			var a = '{"a": [{"b": 2}, {"d":4}]}';
			var b = '{"a": [{"c": 3}, {"e":5}]}';
			var c = '{"a": [1], "b": [2]}';
			var d = '{"a": [3], "b": [4]}';
			var r = '';

			it("behaves different, since it does not merge positional objects inside of arrays", {
				var merged = MergeJson.merge(haxe.Json.parse(a), haxe.Json.parse(b));
				r = haxe.Json.stringify(merged);
				r.should.be('{"a":[{"b":2},{"d":4},{"c":3},{"e":5}]}');
			});

			it("behaves more like the mergeWith example in the lodash docs (with custom merger code)", {
				var merged = MergeJson.merge(haxe.Json.parse(c), haxe.Json.parse(d));
				r = haxe.Json.stringify(merged);
				r.should.be('{"a":[1,3],"b":[2,4]}');
			});
		});
	}
}
