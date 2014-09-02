//
//  OmniGraffle.swift
//  Sketch
//
//  Created by Jonathan Wight on 8/31/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import Foundation

class OmniGraffleNode : NSObject, Node {
    weak var parent : Node?
    var dictionary:NSDictionary!
}

class OmniGraffleGroup : OmniGraffleNode, GroupNode {
    var children : [Node] = []
    
    init(children:[Node]) {
        self.children = children
    }
}

class OmniGraffleShape : OmniGraffleNode {
    var shape:String { get { return dictionary["Shape"] as String } }
    var bounds:CGRect { get { return StringToRect(dictionary["Bounds"] as String) } }
}

class OmniGraffleLine : OmniGraffleNode {
    var start:CGPoint {
        get {
            let strings = dictionary["Points"] as [String]
            return StringToPoint(strings[0])
        }
    }
    var end:CGPoint {
        get {
            let strings = dictionary["Points"] as [String]
            return StringToPoint(strings[1])
        }
    }
}

class OmniGraffleDocumentModel {
    let path: String
    
    init(path: String) {
        self.path = path
    }

    var rootNode: OmniGraffleGroup { get { load(); return _rootNode } }
    var _rootNode: OmniGraffleGroup!
    
    var nodesByID: [String:OmniGraffleNode] = [:]
    
    func load() {
        let data = NSData(contentsOfCompressedFile:path)
        var error:NSString?
        let d = NSPropertyListSerialization.propertyListFromData(data, mutabilityOption: NSPropertyListMutabilityOptions(), format: nil, errorDescription:&error) as NSDictionary!
        self._processRoot(d)
    }
    
    func _processRoot(d:NSDictionary) {
        let graphicslist = d["GraphicsList"] as [NSDictionary]
        var children:[Node] = []
        for graphic in graphicslist {
            if let node = _processDictionary(graphic) {
                children.append(node)
            }
        }
        let group = OmniGraffleGroup(children:children)
        _rootNode = group
    }
    
    func _processDictionary(d:NSDictionary) -> OmniGraffleNode! {
        if let className = d["Class"] as? String {
            switch className {
                case "Group":
                    var children:[Node] = []
                    if let graphics = d["Graphics"] as? [NSDictionary] {
                        children = map(graphics) {
                            (d:NSDictionary) -> OmniGraffleNode in
                            return self._processDictionary(d)
                        }
                    }
                    let group = OmniGraffleGroup(children:children)
                    group.dictionary = d
                    return group
                case "ShapedGraphic":
                    let shape = OmniGraffleShape()
                    shape.dictionary = d
                    return shape
                case "LineGraphic":
                    let line = OmniGraffleLine()
                    line.dictionary = d
                    return line
                default:
                    println("Unknown: \(className)")
            }
        }
        return nil
    }
}

