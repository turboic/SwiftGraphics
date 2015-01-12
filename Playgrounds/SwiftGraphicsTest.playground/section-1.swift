// Playground - noun: a place where people can play

import SwiftGraphics 

let c = NSColor(deviceHue: 1.0, saturation: 1.0, brightness: 1.0, alpha: 1.0)
c.CGColor.colorSpace.name

//struct RGBA {
//    let red:CGFloat = 0.0
//    let green:CGFloat = 0.0
//    let blue:CGFloat = 0.0
//    let alpha:CGFloat = 0.0
//}
//
//typealias RGBA2 = (CGFloat, CGFloat, CGFloat, CGFloat)
//
//sizeof(RGBA2)

//struct Color {
//    let CGColor:CGColorRef?
//
//    init(CGColor:CGColorRef) {
//        self.CGColor = CGColor
//    }
//
//    init(red:CGFloat = 0.0, green:CGFloat = 0.0, blue:CGFloat = 0.0, alpha:CGFloat = 1.0) {
//        self.CGColor = CGColorCreateGenericRGB(red, green, blue, alpha)
//    }
//
//    init(white:CGFloat, alpha:CGFloat = 1.0) {
//        self.CGColor = CGColorCreateGenericGray(white, alpha)
//    }
//
//    static var blackColor = Color(white:0)
//    static var darkGrayColor = Color(white:0.333)
//    static var lightGrayColor = Color(white:0.667)
//    static var whiteColor = Color(white:1)
//    static var grayColor = Color(white:0.5)
//    static var redColor = Color(red:1)
//    static var greenColor = Color(green:1)
//    static var blueColor = Color(blue:1)
//    static var cyanColor = Color(green:1, blue:1)
//    static var yellowColor = Color(red:1, green:1)
//    static var magnetaColor = Color(green:1, blue:1)
//    static var orangeColor = Color(red:1, green:0.5)
//    static var purpleColor = Color(red:0.5, blue:0.5)
//    static var brownColor = Color(red:0.6, green:0.4, blue:0.2)
//    static var clearColor = Color(white:0.0, alpha:0.0)
//
//}
//
//println(sizeof(Color))
//
//print(Color.redColor.CGColor)
//println(NSColor.redColor().CGColor)

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

context.fillColor = CGColor.redColor().withAlpha(0.5)
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

