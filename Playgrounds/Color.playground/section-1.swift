// Playground - noun: a place where people can play

import Cocoa

import SwiftGraphics
import SwiftGraphicsPlayground

func computeParameters(size:CGSize, bitsPerComponent:Int, colorSpace:CGColorSpaceRef, alphaInfo:CGImageAlphaInfo, bitmapInfo:CGBitmapInfo) -> (width:UInt,height:UInt,bitsPerComponent:UInt,bytesPerRow:UInt,colorSpace:CGColorSpace,bitmapInfo:CGBitmapInfo) {

    let colorModel = CGColorSpaceGetModel(colorSpace)

    let numberOfColorComponents:Int = {
        switch colorModel.value {
            case kCGColorSpaceModelMonochrome.value:
                return 1
            case kCGColorSpaceModelRGB.value:
                return 3
            case kCGColorSpaceModelCMYK.value:
                return 4
            default:
                assert(false)
                return 0
        }
    }()

    assert((bitmapInfo.rawValue & CGBitmapInfo.FloatComponents.rawValue != 0) && bitsPerComponent == sizeof(Float) * 8)

    let hasAlphaComponent = alphaInfo != .None && alphaInfo != .Only
    let numberOfComponents:UInt = numberOfColorComponents + (hasAlphaComponent ? 1 : 0)

    let width = UInt(size.width)
    let height = UInt(size.height)
    let bitsPerPixel = UInt(bitsPerComponent) * numberOfComponents
    let bytesPerComponent = bitsPerPixel * numberOfComponents / 8
    let bytesPerRow = width * bytesPerComponent

    let tuple = (width, height, UInt(bitsPerComponent), bytesPerRow, colorSpace, bitmapInfo | CGBitmapInfo(alphaInfo.rawValue))

    return tuple
    }


func validForBitmapContext(# colorSpace:CGColorSpaceRef, # bitsPerPixel:Int, # bitsPerComponent:Int, # alphaInfo:CGImageAlphaInfo, # bitmapInfo:CGBitmapInfo) -> Bool {

    // https://developer.apple.com/library/ios/documentation/GraphicsImaging/Conceptual/drawingwithquartz2d/dq_context/dq_context.html#//apple_ref/doc/uid/TP30001066-CH203-TPXREF101

    let model = CGColorSpaceGetModel(colorSpace)

    let bitmapInfo = CGBitmapInfo(bitmapInfo.rawValue & CGBitmapInfo.FloatComponents.rawValue)

    let tuple = (model.value, bitsPerPixel, bitsPerComponent, alphaInfo, bitmapInfo)

    switch tuple {
        // TODO: kCGColorSpaceModelUnknown????? = -alpha only?
        case (kCGColorSpaceModelUnknown.value, 8, 8, .Only, CGBitmapInfo()): // Mac OS X, iOS
            return true
        case (kCGColorSpaceModelMonochrome.value, 8, 8, .None, CGBitmapInfo()): // Mac OS X, iOS
            return true
        case (kCGColorSpaceModelMonochrome.value, 8, 8, .Only, CGBitmapInfo()): // Mac OS X, iOS
            return true
        case (kCGColorSpaceModelMonochrome.value, 16, 16, .None, CGBitmapInfo()): // Mac OS X
            return true
        case (kCGColorSpaceModelMonochrome.value, 32, 32, .None, CGBitmapInfo.FloatComponents): // Mac OS X
            return true
        case (kCGColorSpaceModelRGB.value, 16, 5, .NoneSkipFirst, CGBitmapInfo()): // Mac OS X, iOS
            return true
        case (kCGColorSpaceModelRGB.value, 32, 8, .NoneSkipFirst, CGBitmapInfo()): // Mac OS X, iOS
            return true
        case (kCGColorSpaceModelRGB.value, 32, 8, .NoneSkipLast, CGBitmapInfo()): // Mac OS X, iOS
            return true
        case (kCGColorSpaceModelRGB.value, 32, 8, .PremultipliedFirst, CGBitmapInfo()): // Mac OS X, iOS
            return true
        case (kCGColorSpaceModelRGB.value, 32, 8, .PremultipliedLast, CGBitmapInfo()): // Mac OS X, iOS
            return true
        case (kCGColorSpaceModelRGB.value, 64, 16, .PremultipliedLast, CGBitmapInfo()): // Mac OS X
            return true
        case (kCGColorSpaceModelRGB.value, 64, 16, .NoneSkipLast, CGBitmapInfo()): // Mac OS X
            return true
        case (kCGColorSpaceModelRGB.value, 128, 32, .NoneSkipLast, CGBitmapInfo.FloatComponents): // Mac OS X
            return true
        case (kCGColorSpaceModelRGB.value, 128, 32, .PremultipliedLast, CGBitmapInfo.FloatComponents): // Mac OS X
            return true
        case (kCGColorSpaceModelCMYK.value, 32, 8, .None, CGBitmapInfo()): // Mac OS X
            return true
        case (kCGColorSpaceModelCMYK.value, 64, 16, .None, CGBitmapInfo()): // Mac OS X
            return true
        case (kCGColorSpaceModelCMYK.value, 128, 32, .None, CGBitmapInfo.FloatComponents): // Mac OS X
            return true
        default:
            return false
    }
}

public extension CGContext {
    class func bitmapContext(size:CGSize, bitsPerComponent:Int, colorSpace:CGColorSpaceRef, alphaInfo:CGImageAlphaInfo, bitmapInfo:CGBitmapInfo) -> CGContext! {

        let p = computeParameters(size, bitsPerComponent, colorSpace, alphaInfo, bitmapInfo)

        return CGBitmapContextCreate(nil, p.width, p.height, p.bitsPerComponent, p.bytesPerRow, p.colorSpace, p.bitmapInfo)
    }
}


let size = CGSize(w:10, h:10)
let colorSpace = CGColorSpaceCreateDeviceRGB()

//     class func bitmapContext(size:CGSize, bitsPerComponent:UInt, colorSpace:CGColorSpaceRef, alphaInfo:CGImageAlphaInfo, bitmapInfo:CGBitmapInfo) -> CGContext! {

let alphaInfo = CGImageAlphaInfo.NoneSkipLast
let bitmapInfo = CGBitmapInfo.FloatComponents

println(validForBitmapContext(colorSpace:colorSpace, bitsPerPixel:32 * 4, bitsPerComponent:32, alphaInfo:alphaInfo, bitmapInfo:bitmapInfo))

//# colorSpace:CGColorSpaceRef, # bitsPerPixel:Int, # bitsPerComponent:Int, # alphaInfo:CGImageAlphaInfo, # bitmapInfo:CGBitmapInfo

let context = CGContextRef.bitmapContext(size, bitsPerComponent:sizeof(Float) * 8, colorSpace: colorSpace, alphaInfo: alphaInfo, bitmapInfo: bitmapInfo)


CGContextSetAllowsAntialiasing(context, false)

context.setFillColor(CGColor.redColor())
CGContextFillRect(context, CGRect(size:size))

CGContextSetBlendMode(context, kCGBlendModeCopy)

context.setFillColor(CGColor.greenColor())
CGContextFillRect(context, CGRect(size:size))

let data:UnsafePointer <Float> = UnsafePointer <Float> (CGBitmapContextGetData(context))
data[0]
data[1]
data[2]
data[3]


context.nsimage










