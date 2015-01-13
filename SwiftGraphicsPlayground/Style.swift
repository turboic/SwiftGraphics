//
//  Style.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/12/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import CoreGraphics

import SwiftGraphics
import SwiftGraphicsPlayground

// #############################################################################

//fillColor
//strokeColor
//lineWidth
//lineCap
//lineJoin
//miterLimit
//lineDash
//lineDashPhase
//flatness
//alpha
//blendMode

public struct Style {
    public var fillColor:CGColor?
    public var strokeColor:CGColor?
    public var lineWidth:CGFloat?
    public var lineCap:CGLineCap?
    public var lineJoin:CGLineJoin?
    public var miterLimit:CGFloat?
    public var lineDash:[CGFloat]?
    public var lineDashPhase:CGFloat?
    public var flatness:CGFloat?
    public var alpha:CGFloat?
    public var blendMode:CGBlendMode?

    public init() {
    }
}

public enum StyleElement {
    case fillColor(CGColor)
    case strokeColor(CGColor)
    case lineWidth(CGFloat)
    case lineCap(CGLineCap)
    case lineJoin(CGLineJoin)
    case miterLimit(CGFloat)
    case lineDash([CGFloat])
    case lineDashPhase(CGFloat)
    case flatness(CGFloat)
    case alpha(CGFloat)
    case blendMode(CGBlendMode)
}

var CGContext_Style_Key = 1

public extension CGContext {
    var style: Style {
        get {
            let style = getAssociatedObject(self, &CGContext_Style_Key) as Style?
            if let style = style {
                return style
            }
            else {
                let style = Style()
                self.style = style
                return style
            }
        }
        set {
            setAssociatedObject(self, &CGContext_Style_Key, newValue)
            self.apply(newValue)
        }
    }

    func apply(style:Style) {
        if let fillColor = style.fillColor {
            setFillColor(fillColor)
        }
        if let strokeColor = style.strokeColor {
            setStrokeColor(strokeColor)
        }
        if let lineWidth = style.lineWidth {
            setLineWidth(lineWidth)
        }
        if let lineCap = style.lineCap {
            setLineCap(lineCap)
        }
        if let lineJoin = style.lineJoin {
            setLineJoin(lineJoin)
        }
        if let miterLimit = style.miterLimit {
            setMiterLimit(miterLimit)
        }
        if let lineDash = style.lineDash {
            setLineDash(lineDash, phase: 0.0)
        }
        if let lineDashPhase = style.lineDashPhase {
            // TODO
        }
        if let flatness = style.flatness {
            setFlatness(flatness)
        }
        if let alpha = style.alpha {
            setAlpha(alpha)
        }
        if let blendMode = style.blendMode {
            setBlendMode(blendMode)
        }
    }
}

public extension CGContext {

    var fillColor:CGColor? {
        get {
            return self.style.fillColor
        }
        set {
            assert(newValue != nil)
            self.style.fillColor = newValue
            setFillColor(newValue!)
        }
    }

    var strokeColor:CGColor? {
        get {
            return self.style.strokeColor
        }
        set {
            assert(newValue != nil)
            self.style.strokeColor = newValue
            setStrokeColor(newValue!)
        }
    }

    var lineWidth:CGFloat? {
        get {
            return self.style.lineWidth
        }
        set {
            assert(newValue != nil)
            self.style.lineWidth = newValue
            setLineWidth(newValue!)
        }
    }

    var lineCap:CGLineCap? {
        get {
            return self.style.lineCap
        }
        set {
            assert(newValue != nil)
            self.style.lineCap = newValue
            setLineCap(newValue!)
        }
    }

    var lineJoin:CGLineJoin? {
        get {
            return self.style.lineJoin
        }
        set {
            assert(newValue != nil)
            self.style.lineJoin = newValue
            setLineJoin(newValue!)
        }
    }

    var lineDash:[CGFloat]? {
        get {
            return self.style.lineDash
        }
        set {
            assert(newValue != nil)
            self.style.lineDash = newValue
            setLineDash(newValue!)
        }
    }

    var lineDashPhase:CGFloat? {
        get {
            return self.style.lineDashPhase
        }
        set {
            assert(newValue != nil)
            self.style.lineDashPhase = newValue
            // TODO
        }
    }

    var flatness:CGFloat? {
        get {
            return self.style.flatness
        }
        set {
            assert(newValue != nil)
            self.style.flatness = newValue
            setFlatness(newValue!)
        }
    }

    var alpha:CGFloat? {
        get {
            return self.style.alpha
        }
        set {
            assert(newValue != nil)
            self.style.alpha = newValue
            setAlpha(newValue!)
        }
    }

    var blendMode:CGBlendMode? {
        get {
            return self.style.blendMode
        }
        set {
            assert(newValue != nil)
            self.style.blendMode = newValue
            setBlendMode(newValue!)
        }
    }

}

//fillColor
//strokeColor
//lineWidth
//lineCap
//lineJoin
//miterLimit
//lineDash
//lineDashPhase
//flatness
//alpha
//blendMode

public extension Style {
    mutating func add(element:StyleElement) {
        switch element {
            case .fillColor(let value):
                self.fillColor = value
            case .strokeColor(let value):
                self.strokeColor = value
            case .lineWidth(let value):
                self.lineWidth = value
            case .lineCap(let value):
                self.lineCap = value
            case .lineJoin(let value):
                self.lineJoin = value
            case .miterLimit(let value):
                self.miterLimit = value
            case .lineDash(let value):
                self.lineDash = value
            case .lineDashPhase(let value):
                self.lineDashPhase = value
            case .miterLimit(let value):
                self.miterLimit = value
            case .lineDash(let value):
                self.lineDash = value
            case .lineDashPhase(let value):
                self.lineDashPhase = value
            case .flatness(let value):
                self.flatness = value
            case .alpha(let value):
                self.alpha = value
            case .blendMode(let value):
                self.blendMode = value
            default:
                assert(false)
        }
    }

    mutating func add(elements:[StyleElement]) {
        for element in elements {
            add(element)
        }
    }

    init(elements:[StyleElement]) {
        self.add(elements)
    }
}

public extension CGContext {

    func with(elements:[StyleElement], block:() -> Void) {
        let style = Style(elements: elements)
        with(style, block)
    }

    func with(style:Style, block:() -> Void) {
        CGContextSaveGState(self)
        self.apply(style)
        block()
        CGContextRestoreGState(self)
    }
}
