(function ($global) { "use strict";
var MergeJson = function() { };
MergeJson.merge = function(left,right,callback) {
	var result = left;
	var _g = 0;
	var _g1 = Reflect.fields(right);
	while(_g < _g1.length) {
		var key = _g1[_g];
		++_g;
		var rightVal = Reflect.field(right,key);
		var leftVal = Reflect.field(left,key);
		if(Reflect.field(left,key) == null) {
			result[key] = rightVal;
		} else {
			if(callback != null) {
				var custom = callback(key,leftVal,rightVal);
				if(custom != null) {
					result[key] = custom;
					continue;
				}
			}
			if(((rightVal) instanceof Array)) {
				var left1 = Reflect.field(left,key);
				var val = rightVal;
				result[key] = left1.concat(val);
			} else if(typeof(rightVal) == "boolean" || typeof(rightVal) == "number" || typeof(rightVal) == "number" && ((rightVal | 0) === rightVal) || typeof(rightVal) == "string") {
				result[key] = rightVal;
			} else {
				result[key] = MergeJson.merge(Reflect.field(left,key),rightVal);
			}
		}
	}
	return result;
};
var Reflect = function() { };
Reflect.field = function(o,field) {
	try {
		return o[field];
	} catch( _g ) {
		return null;
	}
};
Reflect.fields = function(o) {
	var a = [];
	if(o != null) {
		var hasOwnProperty = Object.prototype.hasOwnProperty;
		for( var f in o ) {
		if(f != "__id__" && f != "hx__closures__" && hasOwnProperty.call(o,f)) {
			a.push(f);
		}
		}
	}
	return a;
};
var haxe_iterators_ArrayIterator = function(array) {
	this.current = 0;
	this.array = array;
};
haxe_iterators_ArrayIterator.prototype = {
	hasNext: function() {
		return this.current < this.array.length;
	}
	,next: function() {
		return this.array[this.current++];
	}
};
})({});
