//
//  SVGTests.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 11/21/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import Cocoa
import XCTest
import SwiftGraphics

class SVGTests: XCTestCase {

    func testExample() {
        let xmlText = "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"100%\" height=\"100%\">\r  <polygon points=\"20,20 100,20 100,100 30,110\"/>\r  <path        d=\"M20,20 L100,20 100,100 30,110z\" fill=\"green\" transform=\"translate(100,0)\"/>\r</svg>"
        var error = NSErrorPointer()
        let xmlDocument = NSXMLDocument(XMLString:xmlText, options:0, error:error)
        let parser = SVGParser()
        let svgDocument:SVGDocument = parser.parseDocument(xmlDocument!)
        let image = svgDocument.image(CGSize(w:500, h:500))
        XCTAssertNotNil(image)
    }

    func testPath() {
        let s = "M20,20 L100,20 100,100 30,110z"
        let atoms = Atom.stringToAtoms(s)
        let pathCommands = Atom.atomsToPathCommands(atoms)
    }
}
