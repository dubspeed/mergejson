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
	public static function merge(left:Dynamic, right:Dynamic, ?callback:(key:String, leftVal:Dynamic, rightVal:Dynamic) -> Dynamic) {
		var result:DynamicAccess<Dynamic> = left;

		for (key in Reflect.fields(right)) {
			var rightVal:Dynamic = Reflect.field(right, key);
			var leftVal:Dynamic = Reflect.field(left, key);

			// if the right key does not exist left, then merge without asking
			// else ask for a custom resolve, or use default rules
			if (Reflect.field(left, key) == null) {
				result[key] = rightVal;
			} else {
				if (callback != null) {
					var custom:Dynamic = callback(key, leftVal, rightVal);
					if (custom != null) {
						result[key] = custom;
						continue;
					}
				}

				// default rules, as documented
				if (Std.is(rightVal, Array)) {
					// All arrays get merged
					// { a: [1]} && {a: [2,3]} => {a: [1,2,3]}
					var left:Array<Dynamic> = Reflect.field(left, key);
					var val:Array<Dynamic> = rightVal;
					result[key] = left.concat(val);
				} else if (Std.is(rightVal, Bool) || Std.is(rightVal, Float) || Std.is(rightVal, Int) || Std.is(rightVal, String)) {
					// All "basic types" get overwritten
					// { a: 3 } && { a: 4 } => {a: 4}
					result[key] = rightVal;
				} else {
					// all is left is {}, so we recursivly parse down
					result[key] = merge(Reflect.field(left, key), rightVal);
				}
			}
		}
		return result;
	}
}
