# MergeJson

Merge json B into A, returning the result.


## Default rules

The default rules for the merge described here, for your own custom rules, see next section.

*Note* When the keys do not conflict, the data will be merged and no rules are processed (neither default nor custom).

* When keys do not match, the result is: 
    
   `{a:3} && {b:4} => {a:3, b:4}`

* Objects {} are parsed recursivly, so 

    `{} && {a: {b: {c: 3}}} => {a: {b: {c: 3}}} `

Whenever an existing key is encountered:

* Arrays [] are concatenated

    `{a: [1,2,3]} && {a: [4,5,6]} => {a: [1,2,3,4,5,6]}`

    * *Note* This also goes for top-level arrays:

    `[{a: 1}, {b: 2}] && [{a: 2}, {b: 3}] => [{a: 1}, {b: 2}, {a: 2}, {b: 3}]`

    A positional combination of objects inside an array does not happen.

* simple types (int, string, float, bool) are *overwritten*:

    `{a: 3} && {a: 1} => {a:1}`

*Note* Order of operations is important when merging arrays and simple types, see below.

## Custom rules

The merge function supports an optional third argument which provides a callback in the form of:

```haxe
        var f = (key:String, leftVal:Dynamic, rightVal:Dynamic) -> {
            return leftVal; // returning null here executes the default rule;
        };
``` 

returning null in the callback will trigger the default rules to apply (see above), any other value will the merge result for that key.

## Usage

```
    haxelib install mergejson
```

Add the following to your haxe compiler line or .hxml file:
```
    --library mergejson
```

Write Haxe code, e.g.

```haxe
    import MergeJson;

    class Test {
        public static function main() {
            var a: String = '{"a": 2}';
            var b: String = '{"b": 3}';

            var result: Dynamic = MergeJson.merge(haxe.Json.parse(a), haxe.Json.parse(b));

            // prints {"a":2, "b":3}
            trace(result);
        }
    }
```

## Merging more than two JSON datasets together

Merging multiple datasets is straightforward, the "right to left" rules ensures consistent merges.
Example:

```haxe
    var result: DynamicAccess<Dynamic> = {};
    for (json in all_my_data) {
        result = MergeJson.merge(result, json);
    }
    // result now contains all data
```

## The "right" to "left" rules

All merges follow a "right to left" rule, so the second argument in the call (right) is always merged on top of the first (left):

    ```
        MergeJson.merge("{a:1}", "{a:2}") == "{a:2}";
        MergeJson.merge("{a:2}", "{a:1}") == "{a:1}";

        MergeJson.merge("{a:[1,2]}", "{a:[3,4]}") == "{a:[1,2,3,4]}";
        MergeJson.merge("{a:[3,4]}", "{a:[1,2]}") == "{a:[3,4,1,2]}"; 
    ```

## Examples

Given A:
```json
{
    "test": {
        "another": {
            "level": {
                "int": 1,
                "bool": false,
                "array": [1, 2, 3]
            }
        }
    }
}
```

and B:

```json
{
    "test": {
        "another": {
            "level": {
                "stringy": "go away",
                "bool": true,
                "array": [1, 4, 5],
                "another": {
                    "thing": [1, 3 ,4]
                }
            }
        }
    }
}
```

the merge result is:
```json
{
    "test": {
        "another": {
            "level": {
                "stringy": "go away",
                "bool": true,
                "array": [1, 2, 3, 1, 4, 5],
                "another": {
                    "thing": [1, 3 ,4]
                }
            }
       j
    }
}
```

## License


All files are released under the [Apache License 2.0](LICENSE.txt).

Individual files contain the following tag instead of the full license text:
```
SPDX-License-Identifier: Apache-2.0
```

This enables machine processing of license information based on the SPDX License Identifiers that are available here: https://spdx.org/licenses/.


## Contribution

Contributions via github are very welcome!.