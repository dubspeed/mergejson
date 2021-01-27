package tests;

using buddy.Should;

import haxe.Json;

class MergeWithControl extends buddy.SingleSuite {
	public function new() {
		var a = '{"a": 1}';
		var b = '{"b": 2}';
		var c = '{"a": 2}';

		describe("Given a callback", {
			it("should not call it when no keys conflict", {
				var called = false;
				var f = (key:String, leftVal:Dynamic, rightVal:Dynamic) -> {
					called = true;
					return null;
				};
				var result = MergeJson.merge(Json.parse(a), Json.parse(b), f);
				var r = Json.stringify(result);
				r.should.be('{"a":1,"b":2}');
				called.should.be(false);
			});

			it("should call the callback, when two keys conflict", {
				var result = MergeJson.merge(Json.parse(a), Json.parse(c), (key:String, leftVal:Dynamic, rightVal:Dynamic) -> {
					return 3;
				});
				var r = Json.stringify(result);
				r.should.be('{"a":3}');
			});
		});
	}
}
