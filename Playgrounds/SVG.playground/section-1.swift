// Playground - noun: a place where people can play

import Cocoa
import SwiftGraphics
import SwiftGraphicsPlayground
import XCPlayground

let xmlText = "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"100%\" height=\"100%\">\r  \r  <path        d=\"M20,20 100,20 100,100 30,110z\" fill=\"green\" transform=\"translate(100,0)\"/>\r</svg>"

var error = NSErrorPointer()
let xmlDocument = NSXMLDocument(XMLString:xmlText, options:0, error:error)
let parser = SVGParser()
let svgDocument = parser.parseDocument(xmlDocument!)
svgDocument.image(CGSize(width:500, height:500))
switch svgDocument.commands[1] {
    case .Path(let path):
        path.dump()
        break
    default:
        break
}