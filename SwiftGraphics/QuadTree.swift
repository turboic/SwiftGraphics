//
//  QuadTree.swift
//  QuadTree
//
//  Created by Jonathan Wight on 8/6/14.
//  Copyright (c) 2014 schwa. All rights reserved.
//

import CoreGraphics

private struct QuadTreeConfig {
    let minimumNodeSize : CGSize
    let maximumObjectsPerNode : Int
}

public class QuadTree <T> {
    public var frame : CGRect { get { return self.rootNode.frame } }
    public var rootNode : QuadTreeNode <T>!
    private let config : QuadTreeConfig

    public required init(frame:CGRect, minimumNodeSize:CGSize = CGSize(w:1, h:1), maximumObjectsPerNode:Int = 8) {
        self.config = QuadTreeConfig(minimumNodeSize:minimumNodeSize, maximumObjectsPerNode:maximumObjectsPerNode)
        self.rootNode = QuadTreeNode(config:config, frame:frame)
    }
    
    public func addObject(object:T, point:CGPoint) {
        assert(self.frame.contains(point))
        self.rootNode.addObject(object, point:point)
    }
    
    public func objectsInRect(rect:CGRect) -> [T] {
        assert(self.frame.intersects(rect))
        return self.rootNode.objectsInRect(rect)
    }
    
//    func dump() {
//
//        let walker = Walker <QuadTreeNode <T>> () {
//            return $0.subnodes
//        }
//
//        walker.walk(self.rootNode) {
//            node, depth in
//            let filler = String(count:Int(depth), repeatedValue:Character(" "))
//            println("\(filler)\(node)")
//        }
//    }
}

public class QuadTreeNode <T> {

    typealias Item = (point:CGPoint, object:T)

    public let frame : CGRect
    private let config : QuadTreeConfig

//    var topLeft : QuadTreeNode?
//    var topRight : QuadTreeNode?
//    var bottomLeft : QuadTreeNode?
//    var bottomRight : QuadTreeNode?

    public var subnodes : [QuadTreeNode]?

    // Optional because this can be nil-ed out later.
    public lazy var items : [Item]? = []
    public var objects : [T]? {
        get { 
            if let items = items {
                return items.map() { return $0.object }
            }
            else {
                return nil
            }
        }
    } 

    internal var isLeaf : Bool { get { return self.subnodes == nil } }

    internal var canExpand : Bool { get { return self.frame.size.width >= self.config.minimumNodeSize.width * 2.0 && self.frame.size.height >= self.config.minimumNodeSize.height * 2.0 } }

    private init(config:QuadTreeConfig, frame:CGRect) {
        self.config = config
        self.frame = frame
    }

    func addItem(item:Item) {
        if self.isLeaf {
            self.items!.append(item)
            if items!.count >= self.config.maximumObjectsPerNode && self.canExpand {
                self.expand()
            }
        } else {
            let subnode = self.subnodeForPoint(item.point)
            subnode.addItem(item)
        }
    }

    func addObject(object:T, point:CGPoint) {
        let item = Item(point:point, object:object)
        self.addItem(item)
    }

    func itemsInRect(rect:CGRect) -> [Item] {
        var foundItems:[Item] = []
        if let items = self.items {
            for item in items {
                if rect.contains(item.point) {
                    foundItems.append(item)
                }
            }
        } else {
            for subnode in self.subnodes! {
                if CGRectIntersectsRect(subnode.frame, rect) {
                    foundItems += subnode.itemsInRect(rect)
                }
            }
        }
        return foundItems
    }

    func objectsInRect(rect:CGRect) -> [T] {
        return self.itemsInRect(rect).map { return $0.object }
    }
    
    internal func expand() {
        assert(self.canExpand)
        self.subnodes = [
            QuadTreeNode(config:self.config, frame:self.frame.quadrant(.TopLeft)),
            QuadTreeNode(config:self.config, frame:self.frame.quadrant(.TopRight)),
            QuadTreeNode(config:self.config, frame:self.frame.quadrant(.BottomLeft)),
            QuadTreeNode(config:self.config, frame:self.frame.quadrant(.BottomRight)),
            ]
        for item in self.items! {
            let node = self.subnodeForPoint(item.point)
            node.addItem(item)
        }
        
        self.items = nil
    }

    internal func subnodeForPoint(point:CGPoint) -> QuadTreeNode! {
        assert(self.frame.contains(point))
        let quadrant = Quadrant.fromPoint(point, rect:self.frame)
        let subnode = self.subnodeForQuadrant(quadrant!)
        return subnode
    }

    internal func subnodeForQuadrant(quadrant:Quadrant) -> QuadTreeNode! {
        if let subnodes = self.subnodes {
            switch (quadrant) {
                case .TopLeft:
                    return subnodes[0]
                case .TopRight:
                    return subnodes[1]
                case .BottomLeft:
                    return subnodes[2]
                case .BottomRight:
                    return subnodes[3]
            }
        } else {
            return nil
        }
    }

//    var description: String {
//        get {
//            return "Subnode: [Objects:\(self.objects != nil ? self.objects!.count : -1), Subnodes:\(self.subnodes != nil ? self.subnodes!.count : -1)]"
//        }
//    }
//    var debugDescription: String { get { return "FOO"} }
}
