//
//  Utilities.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/10/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Foundation

extension Array {
    init(count:Int, block:(Void) -> T) {
        self.init()
        for N in 0..<count {
            append(block())
        }
    }
}

public func arrayOfRandomPoints(count:Int, range:CGRect) -> Array <CGPoint> {
    return Array <CGPoint> (count:count) {
        return Random.rng.random(range)
    }
}

extension UInt32 {
    func asHex() -> String {
        var s = ""
        let characters:[Character] = [
            "0","1","2","3","4","5","6","7","8","9",
            "A","B","C","D","E","F",
            ]
        s.append(characters[Int(self >> 28 & 0x0F)])
        s.append(characters[Int(self >> 24 & 0x0F)])
        s.append(characters[Int(self >> 20 & 0x0F)])
        s.append(characters[Int(self >> 16 & 0x0F)])
        s.append(characters[Int(self >> 12 & 0x0F)])
        s.append(characters[Int(self >> 8 & 0x0F)])
        s.append(characters[Int(self >> 4 & 0x0F)])
        s.append(characters[Int(self & 0x0F)])
        
        return s
    }

}

public struct IntegerPoint <T: IntegerType> {
    public var x:T
    public var y:T
    public init(x:T, y:T) {
        self.x = x
        self.y = y
    }
}

public typealias UIntPoint = IntegerPoint <UInt>

public struct IntegerSize <T: IntegerType> {
    public var width:T
    public var height:T
    public init(width:T, height:T) {
        self.width = width
        self.height = height
    }
}

public typealias UIntSize = IntegerSize <UInt>

public struct Bitmap {
    public let size: UIntSize
    public let bitsPerComponent: UInt
    public let bitsPerPixel: UInt
    public let bytesPerRow: UInt
    public let ptr: UnsafeMutablePointer<Void>
    public var bytesPerPixel: UInt { get { return bitsPerPixel / 8 } }

    public init(size:UIntSize, bitsPerComponent:UInt, bitsPerPixel:UInt, bytesPerRow:UInt, ptr:UnsafeMutablePointer <Void>) {
        self.size = size
        self.bitsPerComponent = bitsPerComponent
        self.bitsPerPixel = bitsPerPixel
        self.bytesPerRow = bytesPerRow
        self.ptr = ptr
    }

    public subscript (index:UIntPoint) -> UInt32 {
        assert(index.x < size.width)
        assert(index.y < size.height)
        let offset = index.y * bytesPerRow + index.x * bytesPerPixel
        let offsetPointer = ptr.advancedBy(Int(offset))
        return UnsafeMutablePointer <UInt32> (offsetPointer).memory
    }
}

public extension NSColor {
    convenience init(rgba:UInt32, bgra:Bool = true) {
        let (rs:UInt32, gs:UInt32, bs:UInt32) = bgra ? (8, 16, 24) : (24, 16, 8)
    
    
        let r = CGFloat((rgba >> rs) & 0xFF) / 255
        let g = CGFloat((rgba >> gs) & 0xFF) / 255
        let b = CGFloat((rgba >> bs) & 0xFF) / 255
        let a = CGFloat(rgba & 0b1111_1111) / 255
        self.init(deviceRed:r, green:g, blue:b, alpha:a)
    }
    
    var asUInt32:UInt32 {
        get {
            let r = UInt32(redComponent * 255)
            let g = UInt32(greenComponent * 255)
            let b = UInt32(blueComponent * 255)
            let a = UInt32(alphaComponent * 255)
            return r << 24 | g << 16 | b << 8 | a
        }
    }
}

public extension CGFloat {
    init(string:String) {
        self = CGFloat(string._bridgeToObjectiveC().doubleValue)
    }
}

public func StringToPoint(s:String) -> CGPoint {
    let f = "([0-9.Ee+-]+)"
    let pair = "\\{\(f), \(f)\\}"
    let match = RegularExpression(pair).match(s)!
    let x = CGFloat(string:match.groups[1].string)
    let y = CGFloat(string:match.groups[2].string)
    return CGPoint(x:x, y:y)
}

public func StringToSize(s:String) -> CGSize {
    let f = "([0-9.Ee+-]+)"
    let pair = "\\{\(f), \(f)\\}"
    let match = RegularExpression(pair).match(s)!
    let w = CGFloat(string:match.groups[1].string)
    let h = CGFloat(string:match.groups[2].string)
    return CGSize(w:w, h:h)
}

public func StringToRect(s:String) -> CGRect {
    let f = "([0-9.Ee+-]+)"
    let pair = "\\{\(f), \(f)\\}"
    let match = RegularExpression("\\{\(pair), \(pair)\\}").match(s)!
    let x = CGFloat(string:match.groups[1].string)
    let y = CGFloat(string:match.groups[2].string)
    let w = CGFloat(string:match.groups[3].string)
    let h = CGFloat(string:match.groups[4].string)
    return CGRect(x:x, y:y, width:w, height:h)
}

/**
 *  A struct that acts like an array but returns results from a block
 */
public struct BlockBackedCollection <T> : CollectionType, SequenceType {
    public typealias Element = T
    public typealias Index = Int
    public typealias Block = (index:Index) -> T
    public typealias Generator = BlockBackedCollectionGenerator <T>

    public var startIndex: Index { get { return 0 } }
    public var endIndex: Index { get { return count } }
    public let count: Int
    public let block: Block

    public init(count:Index, block:Block) {
        self.count = count
        self.block = block
    }

    public subscript (index:Index) -> T {
        assert(index > 0 && index < self.count)
        return block(index: index)
    }

    public func generate() -> Generator {
        return Generator(sequence:self)
    }
}

public struct BlockBackedCollectionGenerator <T> : GeneratorType {
    public typealias Sequence = BlockBackedCollection <T>
    public typealias Element = Sequence.Element
    public typealias Index = Sequence.Index
    public typealias Block = Sequence.Block

    public let startIndex: Index = 0
    public var endIndex: Index { get { return count } }
    public let count: Int
    public let block: Block
    public var nextIndex: Index = 0

    public init(sequence:Sequence) {
        self.count = sequence.count
        self.block = sequence.block
    }
        
    public mutating func next() -> Element? {
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
