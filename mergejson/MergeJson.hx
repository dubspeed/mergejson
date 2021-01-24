/*
 * Copyright 2020 Michael Engel
 * SPDX-License-Identifier: Apache-2.0
 */

import haxe.DynamicAccess;

class MergeJson {
	/*
	 * Merge Json 'right' into 'left', returning the result.
	 * Rules of merge are:
	 * Arrays are concatenated,
	 * Objects are parsed recursivly
	 * simple types (int, string, float, bool) are overwritten: left -> right
	 */
	public static function merge(left:Dynamic, right:Dynamic):Dynamic {
		var result:DynamicAccess<Dynamic> = left;

		for (key in Reflect.fields(right)) {
			var value:Dynamic = Reflect.field(right, key);

			if (Reflect.field(left, key) == null) {
				result[key] = value;
			} else {
				if (Std.is(value, Array)) {
					// All arrays get merged
					// { a: [1]} && {a: [2,3]} => {a: [1,2,3]}
					var left:Array<Dynamic> = Reflect.field(left, key);
					var val:Array<Dynamic> = value;
					result[key] = left.concat(val);
				} else if (Std.is(value, Bool) || Std.is(value, Float) || Std.is(value, Int) || Std.is(value, String)) {
					// All "basic types" get overwritten
					// { a: 3 } && { a: 4 } => {a: 4}
					result[key] = value;
				} else {
					// all is left is {}, so we recursivly parse down
					result[key] = merge(Reflect.field(left, key), value);
				}
			}
		}
		return result;
	}
}
