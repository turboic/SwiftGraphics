# SwiftGraphics

## *IMPORTANT*

Most interesting development happens on the [develop][develop] branch.

[develop]: https://github.com/schwa/SwiftGraphics/tree/develop

[![Travis][travis_img]][travis]

[travis]: https://travis-ci.org/schwa/SwiftGraphics
[travis_img]: https://travis-ci.org/schwa/SwiftGraphics.svg?branch=master

## Bringing Swift goodness to Quartz.

See [TODO.markdown][TODO] for short term plans.
See "Help Wanted" section of this document for how you can contribute to SwiftGraphics.

[TODO]: TODO.markdown

## Philosophy

Wrap Quartz (and other related Frameworks such as CoreImage) in a nice "Swifthonic" API.

Provide wrappers and operators to help make working with graphics primitives in swift as 
convenient as possible.

## What's included

* Pragmatic operator overloading for CoreGraphics types including: CGPoint, CGSize,
CGRect, CGAffineTransform
* Object Oriented extensions for CGContext, CGPath
* A bezier curve object that can represent curves of any order (including quadratic and
cubic of course)
* A path object that represents a bezier path - can be used to create and manipulate
paths in a more natural way than CGPath or NSBezierPath can do 
* Convex Hull Generation
* QuadTree data structure
* Metaballs (Marching Squares algorithm) implementation

![Convex Hull Screenshot](Documentation/ConvexHull.png)
![Metaballs Screenshot](Documentation/Metaballs.png)
![QuadTree Screenshot](Documentation/QuadTree.png)
![Ellipse Screenshot](Documentation/Ellipse.png)


## In Progress

All of this code is very much a _*work in progress*_. I'm adding and changing
functionality as needed. As such I'm trying not to add code that isn't used (with some
exceptions).

Look in the Demo directory for "bleeding edge" projects that are adding new functionality
to SwiftGraphics.

## Usage

SwiftGraphics builds iOS and OSX frameworks. Just add SwiftGraphics.xcodeproj to your
project and set up your dependencies appropriately.

You can play with SwiftGraphics in Xcode 6 Playgrounds.
Use Demos/SwiftGraphicsDemos.xcworkspace.

## Help Wanted

Your help wanted. I would definitely appreciate contributions from other members of the 
Swift/Cocoa community. Please fork this project and submit pull requests.

You can help by using Swift Graphics in your projects and discovering its shortcomings. I encourage you to file [issues][issues] against this project.

[issues]: https://github.com/schwa/SwiftGraphics/issues

Contributions are always welcome in the following areas:

* Header doc comments explaining what the functions do
* Unit tests
* Playgrounds showing graphically what SwiftGraphics can do
* New graphical algorithms (take your pick from [wikipedia][wikipedia])
* New geometry structs

[wikipedia]: https://en.wikipedia.org/wiki/Category:Computer_graphics_algorithms

## Naming

"SwiftGraphics" is a placeholder name. Please send your suggestions for a better name on a
self-addressed, stamped postcard to…

## License

See LICENSE for more information
