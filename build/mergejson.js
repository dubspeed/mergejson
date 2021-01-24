// Generated by Haxe 4.1.5
(function ($global) { "use strict";
var MergeJson = function() { };
MergeJson.merge = function(left,right) {
	var result = left;
	var _g = 0;
	var _g1 = Reflect.fields(right);
	while(_g < _g1.length) {
		var key = _g1[_g];
		++_g;
		var value = Reflect.field(right,key);
		if(Reflect.field(left,key) == null) {
			result[key] = value;
		} else if(((value) instanceof Array)) {
			var left1 = Reflect.field(left,key);
			var val = value;
			result[key] = left1.concat(val);
		} else if(typeof(value) == "boolean" || typeof(value) == "number" || typeof(value) == "number" && ((value | 0) === value) || typeof(value) == "string") {
			result[key] = value;
		} else {
			result[key] = MergeJson.merge(Reflect.field(left,key),value);
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
