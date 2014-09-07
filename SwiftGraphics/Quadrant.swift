//
//  Quadrant.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 8/24/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import CoreGraphics

// MARK: Quadrants

public enum Quadrant {
    case TopLeft
    case TopRight
    case BottomLeft
    case BottomRight
}

public extension Quadrant {
    static func fromPoint(point:CGPoint) -> Quadrant {
        if (point.y >= 0) {
            if (point.x >= 0) {
                return(.TopRight)
            }
            else {
                return(.TopLeft)
            }
        }
        else {
            if (point.x >= 0) {
                return(.BottomRight)
            }
            else {
                return(.BottomLeft)
            }
        }
    }

    static func fromPoint(point:CGPoint, origin:CGPoint) -> Quadrant {
        return Quadrant.fromPoint(point - origin)
    }

    static func fromPoint(point:CGPoint, rect:CGRect) -> Quadrant? {
        // TODO:  can be ouside
        return Quadrant.fromPoint(point - rect.mid)
    }

    // TODO: Deprecate
    func quadrantRectOfRect(rect:CGRect) -> CGRect {
        return rect.quadrant(self)
    }
}

extension CGRect {
    func quadrant(quadrant:Quadrant) -> CGRect {
        let size = CGSize(width:self.size.width * 0.5, height:self.size.height * 0.5)
        switch quadrant {
        case .TopLeft:
            return CGRect(origin:CGPoint(x:self.minX, y:self.midY), size:size)
        case .TopRight:
            return CGRect(origin:CGPoint(x:self.midX, y:self.midY), size:size)
        case .BottomLeft:
            return CGRect(origin:CGPoint(x:self.minX, y:self.minY), size:size)
        case .BottomRight:
            return CGRect(origin:CGPoint(x:self.midX, y:self.minY), size:size)
        }
    }
}


