package tests;

using buddy.Should;

class MergeRulesTest extends buddy.SingleSuite {
	public function new() {
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
	}
}
