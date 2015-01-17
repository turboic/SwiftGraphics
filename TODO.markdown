# TODO

SwiftGraphics is currently a WIP - the API will change radically.

* TODO: Documentation
* TODO: Unit Tests
* TODO: Double check operater precidence - forced to do some weird casting right
now
* TODO: Might end up wrapping CGContext (and other CG types) in swift classes
just so I get full benefit of swift. For example you can't create class methods
on CGContext etc. NOTE: I was wrong about class methods. Extending CGContext is
somewhat viable.

## SVG

#### NOTE THIS HAS MOVED OUT OF THIS REPO TEMPORARILY

See https://github.com/schwa/SwiftGraphics/commit/cf3408e266c54cde8df7019c62309b7a1a061e71 for the last good commit with SVG in.

SwiftGraphics could (should?) have basic support for SVG. Supporting the full
SVG spec is nuts. But supporting enough of SVG so we can use it as an
NSBezierPath persistence format is a good idea.

* Basic SVG support now works
* TODO: Transformation stack in groups
* TODO: Arc primitives of path element
* TODO: Shortcut bezier primitives of path element
* TODO: More attributes of basic types like rectangle etc.
* TODO: Basic style (stack) support
* TODO: Wrap code up in simple API
* TODO: Persistence into a binary format - allowing loading of scalable graphics
from disk without parsin SVG

## OmniGraffle

See UITest target for an example of import OmniGraffle documents.
