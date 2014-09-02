//
//  SketchOmniGraffle.swift
//  Sketch
//
//  Created by Jonathan Wight on 9/2/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import Foundation

func loadTest() -> Node {
    let path = "/Users/schwa/Desktop/Test.graffle"
    let doc = OmniGraffleDocumentModel(path: path)
    let root = convert(doc.rootNode)
    return root
}

internal func convert(input:OmniGraffleNode) -> Node! {
    // TODO: Can replace with switch pattern matching?
    
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
    
//    if input is OmniGraffleGroup {
//        return convert(input as OmniGraffleGroup)
//    }
//    else if input is OmniGraffleShape {
//        return convert(input as OmniGraffleShape)
//    }
//    else if input is OmniGraffleLine {
//        return convert(input as OmniGraffleLine)
//    }
//    return nil
}

internal func convert(input:OmniGraffleGroup) -> Node! {
    let group = Group()
    group.children = input.children.map {
        (node:Node) -> Node in
        return convert(node as OmniGraffleNode)
    }
    return group
}

internal func convert(input:OmniGraffleShape) -> Node! {
    let shapeName = input.dictionary["Shape"] as String
    switch shapeName {
        case "Circle":
            return Circle(name:"Hello", center:input.bounds.mid, radius:input.bounds.size.width * 0.5)
        case "Rectangle":
            return Rectangle(name:"Hello", frame:input.bounds)
////                    case "Bezier":
////                        println(d)
//                        return nil
        default:
            println("Unknown shape: \(shapeName)")
            return nil
    }
}

internal func convert(input:OmniGraffleLine) -> Node! {
    let shape = Line(name:"Hello", start:input.start, end:input.end)
    return shape
}
