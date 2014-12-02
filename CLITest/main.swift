//
//  main.swift
//  CLITest
//
//  Created by Jonathan Wight on 11/20/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import AppKit

let xmlText = "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"100%\" height=\"100%\">\r  <polygon points=\"20,20 100,20 100,100 30,110\"/>\r  <path        d=\"M20,20 100,20 100,100 30,110z\" fill=\"green\" transform=\"translate(100,0)\"/>\r</svg>"

var error = NSErrorPointer()
let xmlDocument = NSXMLDocument(XMLString:xmlText, options:0, error:error)
let parser = SVGParser()
let svgDocument = parser.parseDocument(xmlDocument!)
let image = svgDocument.image()

println(svgDocument.commands)

println("HELLO \(image)")
