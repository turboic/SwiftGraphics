// Playground - noun: a place where people can play

import SwiftGraphics 

extension CGColor {
    func colorWithAlpha(alpha:CGFloat) -> CGColor {
        return CGColorCreateCopyWithAlpha(self, alpha)
    }
}

extension CGColor {
    class func whiteColor() -> CGColor {
        return NSColor.whiteColor().CGColor
    }
    class func blackColor() -> CGColor {
        return NSColor.blackColor().CGColor
    }
    class func redColor() -> CGColor {
        return NSColor.redColor().CGColor
    }
    class func greenColor() -> CGColor {
        return NSColor.greenColor().CGColor
    }
}

func * (lhs:CGColor, rhs:CGFloat) -> CGColor {
    return lhs.colorWithAlpha(rhs)
}

struct Styles {
    var fillColor:CGColor?
    var strokeColor:CGColor?
    var lineWidth:CGFloat?
    var lineDash:[CGFloat]?


    init() {
    }
}


@objc class StructWrapper {
    var wrapped:Any
    init(wrapped:Any) {
        self.wrapped = wrapped
    }
}

var CGContext_Style_Key = 1

extension CGContext {

    var styles: Styles {
        get {
            var wrapper = objc_getAssociatedObject(self, &CGContext_Style_Key) as? StructWrapper
            if let wrapper = wrapper {
                return wrapper.wrapped as Styles
            }
            else {
                let styles = Styles()
                self.styles = styles
                return styles
            }
        }
        set {
            let wrapper = StructWrapper(wrapped:newValue)
            objc_setAssociatedObject(self, &CGContext_Style_Key, wrapper, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        }
    }

    var fillColor:CGColor? {
        get {
            return self.styles.fillColor
        }
        set {
            self.styles.fillColor = newValue
            CGContextSetFillColorWithColor(self, newValue)
        }
    }

    var strokeColor:CGColor? {
        get {
            return self.styles.strokeColor
        }
        set {
            self.styles.strokeColor = newValue
            CGContextSetStrokeColorWithColor(self, newValue)
        }
    }

    var lineWidth:CGFloat? {
        get {
            return self.styles.lineWidth
        }
        set {
            self.styles.lineWidth = newValue
            CGContextSetLineWidth(self, newValue!)
        }
    }

    var lineDash:[CGFloat]? {
        get {
            return self.styles.lineDash
        }
        set {
            self.styles.lineDash = newValue
            setLineDash(newValue!)
        }
    }

    func apply(styles:Styles) {
        if let strokeColor = styles.strokeColor {
            CGContextSetStrokeColorWithColor(self, strokeColor)
        }
        if let lineWidth = styles.lineWidth {
            CGContextSetLineWidth(self, lineWidth)
        }
    }
}

public extension CGContext {

    func setStrokeColor(color:CGColor) {
        CGContextSetStrokeColorWithColor(self, color)
    }
    func setFillColor(color:CGColor) {
        CGContextSetFillColorWithColor(self, color)
    }
    func setLineWidth(width:CGFloat) {
        CGContextSetLineWidth(self, width)
    }
    func setLineDash(lengths:[CGFloat]) {
        lengths.withUnsafeBufferPointer {
            (buffer:UnsafeBufferPointer<CGFloat>) -> Void in
            CGContextSetLineDash(self, 0.0, buffer.baseAddress, UInt(lengths.count))
        }
    }
}

enum Style {
    case strokeColor(CGColor)
    case lineWidth(CGFloat)
}

extension Styles {
    mutating func add(style:Style) {
        switch style {
            case .strokeColor(let value):
                self.strokeColor = value
            case .lineWidth(let value):
                self.lineWidth = value
        }
    }
}

func | (lhs:Style, rhs:Style) -> Styles {
    var styles = Styles()
    styles.add(lhs)
    styles.add(rhs)
    return styles
}

//func | (lhs:Style, rhs:StyleElement) -> Style {
//    var style = Style()
//    // TODO: Copy style
//    style.add(rhs)
//    return lhs
//}

extension CGContext {

    func with(style:Styles, block:() -> Void) {
        CGContextSaveGState(self)
        self.apply(style)
        block()
        CGContextRestoreGState(self)
    }
}

// ###################################################

let context = CGContextRef.bitmapContext(CGSize(w:512, h:512))

let center = CGPoint(x:200, y:200)
let radius:CGFloat = 100

context.fillColor = CGColor.redColor() * 0.5
context.fillCircle(center:center, radius:radius)

// From: http://www.faqs.org/faqs/graphics/algorithms-faq/ section 4.04
let d = radius * 4 * (sqrt(2) - 1) / 3

context.with() {

    context.strokeColor = CGColor.blackColor()
    context.lineWidth = 4
    context.lineDash = [10, 10]

    let quadrants = [
        CGPoint(x:1.0, y:1.0),
        CGPoint(x:1.0, y:-1.0),
        CGPoint(x:-1.0, y:1.0),
        CGPoint(x:-1.0, y:-1.0),
    ]
    for quadrant in quadrants {
        // Create a cubic bezier curve for the current quadrant of the circle...
        var curve = BezierCurve(
            start:center + CGPoint(x:radius) * quadrant,
            control1:center + (CGPoint(x:radius) + CGPoint(y:d)) * quadrant,
            control2:center + (CGPoint(y:radius) + CGPoint(x:d)) * quadrant,
            end:center + CGPoint(y:radius) * quadrant
            )

        // Stroke the quadrant curve
        context.stroke(curve)

        // Draw each point of the bezier curve with a custom style
        let styles = Style.strokeColor(CGColor.greenColor())
            | Style.lineWidth(context.lineWidth! * 0.5)
        context.with(styles) {
            context.lineDash = [1]
            for point in curve.points {
                context.strokeSaltire(CGRect(center: point, radius:10))
            }
        }
    }
}















//var path = CGPathCreateMutable()
//path.move(CGPoint(x:0, y:0))
//path.addLine(CGPoint(x:100, y:0), relative:true)
//path.addLine(CGPoint(x:0, y:100), relative:true)
//path.addLine(CGPoint(x:-100, y:0), relative:true)
//path.addLine(CGPoint(x:0, y:-100), relative:true)
//
//CGContextAddPath(context, path)
//CGContextStrokePath(context)

context.nsimage

