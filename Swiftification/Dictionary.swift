//
// Copyright (c) 2016 Hilton Campbell
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import Foundation

public extension Dictionary {
    
    init(elements: [(Key, Value)]) {
        self.init()
        for (key, value) in elements {
            self[key] = value
        }
    }
    
    /// Passthrough 'safe' subscript to make linters happy
    /// (because SwiftLint can't currently differentiate between array and dictionary subscripts)
    subscript(safe key: Key) -> Value? {
        get {
            return self[key]
        }
        set {
            self[key] = newValue
        }
    }
    
    /// Returns the union of `self` and the other dictionaries. If more than
    /// one dictionary has the same key, it will take on the rightmost
    /// dictionary's value.
    
    func union(_ first: Dictionary, _ rest: Dictionary...) -> Dictionary {
        var result = self
        for dictionary in [first] + rest {
            for (key, value) in dictionary {
                result[key] = value
            }
        }
        return result
    }
    
    /// Unions the other dictionaries with `self`. If more than
    /// one dictionary has the same key, it will take on the rightmost
    /// dictionary's value.
    mutating func formUnion(_ first: Dictionary, _ rest: Dictionary...) {
        for dictionary in [first] + rest {
            for (key, value) in dictionary {
                self[key] = value
            }
        }
    }

    /// Returns a new dictionary by running a map on each key and getting a new value
    
    func mapValues<V>(_ map: (Key, Value) -> V) -> [Key: V] {
        var results = [Key: V]()
        for (key, value) in self {
            results[key] = map(key, value)
        }
        
        return results
    }
    
    /// Returns an Array with values generated by running each [key: value] of self through the mapFunction.
    
    func toArray<V>(_ map: (Key, Value) -> V) -> [V] {
        var mapped = [V]()
        for (key, value) in self {
            mapped.append(map(key, value))
        }
        return mapped
    }
    
}

/// Returns the union of the two dictionaries. For any keys that both
/// dictionaries have in common, the result will take on the value from the
/// right dictionary.
public func | <K, V>(lhs: Dictionary<K, V>, rhs: Dictionary<K, V>) -> Dictionary<K, V> {
    return lhs.union(rhs)
}

/// Unions two dictionaries. For any keys that both dictionaries have
/// in common, the left dictionary will take on the value from the right.
public func |= <K, V>(lhs: inout Dictionary<K, V>, rhs: Dictionary<K, V>) {
    lhs.formUnion(rhs)
}
