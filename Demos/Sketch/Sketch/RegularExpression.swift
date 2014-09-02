//
//  RegularExpression.swift
//  Sketch
//
//  Created by Jonathan Wight on 8/31/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import Foundation

/**
 *  A struct that acts like an array but returns results from a block
 */
struct BlockBackedCollection <T> : CollectionType, SequenceType {
    typealias Element = T
    typealias Index = Int
    typealias Block = (index:Index) -> T
    typealias Generator = BlockBackedCollectionGenerator <T>

    var startIndex: Index { get { return 0 } }
    var endIndex: Index { get { return count } }
    let count: Int
    let block: Block

    init(count:Index, block:Block) {
        self.count = count
        self.block = block
    }

    subscript (index:Index) -> T {
        assert(index > 0 && index < self.count)
        return block(index: index)
    }

    func generate() -> Generator {
        return Generator(sequence:self)
    }
}

struct BlockBackedCollectionGenerator <T> : GeneratorType {
    typealias Sequence = BlockBackedCollection <T>
    typealias Element = Sequence.Element
    typealias Index = Sequence.Index
    typealias Block = Sequence.Block

    let startIndex: Index = 0
    var endIndex: Index { get { return count } }
    let count: Int
    let block: Block
    var nextIndex: Index = 0

    init(sequence:Sequence) {
        self.count = sequence.count
        self.block = sequence.block
    }
        
    mutating func next() -> Element? {
        if nextIndex >= endIndex {
            return nil
        }
        else if nextIndex < endIndex {
            let element = block(index:nextIndex++)
            return element
        }
        else {
            return nil
        }
    }
}

// MARK : foo

struct RegularExpression {

    let expression: NSRegularExpression

    init(_ pattern:String, options:NSRegularExpressionOptions = NSRegularExpressionOptions()) {
        var error:NSError?
        let expression = NSRegularExpression(pattern:pattern, options:options, error:&error)
        assert(error == nil)
        self.expression = expression
        
    }

    func match(string:String, options:NSMatchingOptions = NSMatchingOptions()) -> Match? {
        let range = 0..<string._bridgeToObjectiveC().length
        if let result = expression.firstMatchInString(string, options:options, range:NSRange(range)) {
            return Match(string:string, result:result)
        }
        else {
            return nil
        }
    }

    struct Match {
        let string: String
        let result: NSTextCheckingResult
        
        init(string:String, result:NSTextCheckingResult) {
            self.string = string
            self.result = result
        }

        typealias Groups = BlockBackedCollection <Group>

        var groups : Groups {
            get {
                let count = result.numberOfRanges
                let groups = Groups(count:count) {
                    (index:Int) -> Group in
                    let range = self.result.rangeAtIndex(index)
                    let string = self.string._bridgeToObjectiveC().substringWithRange(range)
                    let group = Group(string:string, range:range)
                    return group
                    }
                return groups
            }
        }

        struct Group {
            let string: String
            let range: NSRange
            
            init(string:String, range:NSRange) {
                self.string = string
                self.range = range
            }
        }
    }
}

//let groups = RegularExpression("([A-Za-z]+) ([A-Za-z]+)").match("Hello world").groups
//
//for f in groups {
//    println(f.string)
//}
