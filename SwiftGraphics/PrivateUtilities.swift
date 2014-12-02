//
//  PrivateUtilities.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 8/27/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import Foundation
import CoreGraphics

// Utility code that is used by SwiftGraphics but isn't intended to be used outside of this project
// Some of this code is embarrasing.

extension CGFloat {
    init(_ string:String) {
        self = CGFloat(string._bridgeToObjectiveC().doubleValue)
    }
}

func parseDimension(string:String) -> (CGFloat, String)! {
    let pattern = NSRegularExpression(pattern:"([0-9]+)[ \t]*(px|%)?", options:.CaseInsensitive, error:nil)
    let range = NSMakeRange(0, string._bridgeToObjectiveC().length)
    let match = pattern!.firstMatchInString(string, options:NSMatchingOptions(), range:range)
    // TODO: Check for failures
    if let match = match {
        let scalar = string._bridgeToObjectiveC().substringWithRange(match.rangeAtIndex(0))
        let unit = string._bridgeToObjectiveC().substringWithRange(match.rangeAtIndex(1))
        return (CGFloat(scalar), unit)
    }
    else {
        return nil
    }
}

extension Character {
    // TODO: LOL
    var isLowercase : Bool { get { return contains("abcdefghijklmnopqrstuvwxyz", self) } } 
}

func + (lhs:NSCharacterSet, rhs:NSCharacterSet) -> NSCharacterSet {
    let result = NSMutableCharacterSet()
    result.formUnionWithCharacterSet(lhs)
    result.formUnionWithCharacterSet(rhs)
    return result
}

let delimiters = NSCharacterSet.whitespaceAndNewlineCharacterSet() + NSCharacterSet(charactersInString: ",")

extension NSScanner {

    var remaining:String {
        get {
            return self.string._bridgeToObjectiveC().substringFromIndex(self.scanLocation)
        }
    }

    func scanCGFloat() -> CGFloat? {
        var d:Double = 0
        if self.scanDouble(&d) {
            return CGFloat(d)
        }
        else {
            return nil
        }
    }

    func scanCGPoint(strict:Bool = true) -> CGPoint? {
        let x = scanCGFloat()
        self.scanCharactersFromSet(delimiters, intoString:nil)
        let y = scanCGFloat()
        if strict == true {
            if x != nil && y != nil {
                return CGPoint(x:x!, y:y!)
            }
        }
        else {
            if x != nil {
                return CGPoint(x:x!, y:y != nil ? y! : 0.0)
            }
        }
        return nil
    }

    func scanCGFloatsSeparatedByCharacterSet(characterSet:NSCharacterSet) -> [CGFloat]? {
        let scanLocation = self.scanLocation

        var floats:[CGFloat] = []

        while self.atEnd == false {
            let float = self.scanCGFloat()
            if float == nil {
                break
            }
            floats.append(float!)

            if scanCharactersFromSet(characterSet, intoString:nil) == false {
                break
            }
        }

        return floats
    }

//    func scanBlockSeperatedByString(string:String, block:() -> ()) -> Bool {
//        return false
//    }
}

/**
 :example:
    let (a,b) = ordered(("B", "A"))
 */
public func ordered <T:Comparable> (tuple:(T, T)) -> (T, T) {
    let (lhs, rhs) = tuple
    if lhs <= rhs {
        return (lhs, rhs)
    }
    else {
        return (rhs, lhs)
    }
}

