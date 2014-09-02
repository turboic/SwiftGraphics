//
//  SketchOmniGraffle.swift
//  Sketch
//
//  Created by Jonathan Wight on 9/2/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import Foundation

import SwiftGraphics

func loadTest() -> Node {
    let path = NSBundle.mainBundle().pathForResource("Test", ofType:"graffle")
    let doc = OmniGraffleDocumentModel(path: path!)
    let root = convert(doc.rootNode)
    return root
}

internal func convert(input:OmniGraffleNode) -> Node! {
    switch input {
        case let input as OmniGraffleGroup:
            return convert(input)
        case let input as OmniGraffleShape:
            return convert(input)
        case let input as OmniGraffleLine:
            return convert(input)
        default:
            return nil
    }
}

internal func convert(input:OmniGraffleGroup) -> Node! {
    let group = Group()
    group.children = input.children.map {
        (node:Node) -> Node in
        return convert(node as OmniGraffleNode)
    }
    return group
}


enum GraphicsOrigin {
    case TopLeft
    case BottomLeft
    case Native

    var resolved : GraphicsOrigin {
        get {
            switch self {
                case .TopLeft, .BottomLeft:
                    return self
                case .Native:
                    #if os(OSX)
                    return .TopLeft
                    #else
                    return .BottomLeft
                    #endif
            }
        }
    }

    var isNative : Bool {
        get {
            switch self {
                case .TopLeft:
                    #if os(OSX)
                    return false
                    #else
                    return true
                    #endif
                case .BottomLeft:
                    #if os(OSX)
                    return true
                    #else
                    return false
                    #endif
                case .Native:
                    return true
            }
        }
    }
}

extension CGPoint {
    func flipped(origin:GraphicsOrigin, insideRect:CGRect) -> CGPoint {
        if origin.isNative {
            return self
        }
        else {
            return self * CGAffineTransform(tx:0, ty:insideRect.size.height).scaled(sx:1, sy:-1)
        }
    }
}

extension CGRect {
    func flipped(origin:GraphicsOrigin, insideRect:CGRect) -> CGRect {
        if origin.isNative {
            return self
        }
        else {
            return self * CGAffineTransform(tx:0, ty:insideRect.size.height).scaled(sx:1, sy:-1)
        }
    }
}

internal func convert(input:OmniGraffleShape) -> Node! {
    let shapeName = input.dictionary["Shape"] as String
    switch shapeName {
        case "Circle":
            println(input.bounds)
            let bounds = input.bounds.flipped(.TopLeft, insideRect:CGRect(w:1024, h:768))
            println(bounds)
            return Circle(name:"Hello", center:bounds.mid, radius:bounds.size.width * 0.5)
        case "Rectangle":
            let bounds = input.bounds.flipped(.TopLeft, insideRect:CGRect(w:1024, h:768))
            return Rectangle(name:"Hello", frame:bounds)
////                    case "Bezier":
////                        println(d)
//                        return nil
        default:
            println("Unknown shape: \(shapeName)")
            return nil
    }
}

internal func convert(input:OmniGraffleLine) -> Node! {
    let start = input.start.flipped(.TopLeft, insideRect:CGRect(w:1024, h:768))
    let end = input.end.flipped(.TopLeft, insideRect:CGRect(w:1024, h:768))

    let shape = Line(name:"Hello", start:start, end:end)
    return shape
}
