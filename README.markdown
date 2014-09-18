# SwiftGraphics

Bringing Swift goodness to Quartz.

See TODO.markdown for short term plans.

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

## Naming

"SwiftGraphics" is a placeholder name. Please send your suggestions for a better name on a
self-addressed, stamped postcard to…

## License

See LICENSE for more information
