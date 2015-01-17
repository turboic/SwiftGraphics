# Project Notes

General notes and philosophies concerning SwiftGraphics.

## Preface

I’ll be referring to structs, classes and enums as “objects” collectively. Swift blurs the lines between these constructs.

## Extensions

The main object definition should contain the bare minimum code needed to define the object.

Use extensions to flesh out the logic of the object. Use extensions to organise code.

Reducing typing is not the same as reducing complexity. Extensions should not be used merely to reduce the number of keys the programmer must hit. Extensions should be used to reduce error possibilities, reduce complexity and construct useful abstractions.

If an extension method is only consumed once, consider not using an extension. Overly specific extension method are not usually useful. If there are benefits to an extension method even if it is only used once - consider a nested function or closure. Failing that mark the extension as internal/private.

## Source Files

Source files should be kept relatively short (average line count is ~100 lines currently).

It’s acceptable to define multiple objects in one swift file as long as they’re relatively short and simple (and the total file length is relatively short).

It’s acceptable to put an object’s extensions in another file if the extension code is not related to the primary aspect of the object. For example if you were to define a String object you could have String.swift, String+Drawing.swift, String+TextToSpeech.swift.

Use <ObjectName>+<AspectName>.swift style naming.

## Operators

Friends don’t let friends define new operators.

Do not invent new operators recklessly (if at all). So far SwiftGraphics has added a ==? (equality with inaccuracy) operator and a ** (to the power of). Both operators are strongly justified. The ==? operator is incredibly useful when dealing with floating point math, the ** operator is a common operator in other languages (and is just very convenient).

Do not make an existing operator do something utterly different. + should always be some kind of additive operation for example.

Operator behaviour should be mostly obvious to someone looking at the operator for the first time “somePoint + someOtherPoint” is obvious “somePoint <<= someOtherPoint” is not.

The associative law should apply where this makes sense (A+B == B+A).

## Functional Programming

Say something inflammatory here about functional programming.

## Private Code

Code that isn’t directly graphics related should generally be marked as private or internal.

## Inheritance

The ease of use of Swift protocols can often make protocols are far better solution to classify types and behaviours. In fact with structs and enums protocols are your only mechanism there.

(TODO: Replace this with a section on protocols instead)

## NSObject, @objc, dynamic, etc

Don’t inherit your classes from NSObject unless you absolutely need to.

Pure swift protocols are far more limited than @objc protocols alas.

## Naming

## schwa’s rule of class naming

If you have to refer to a thesaurus to name something, your code is probably badly thought, over engineered or both.

### CFTypes

Swift allows you to refer to the CFType name directly. E.g. “CGContext” instead of “CGContextRef”. Avoid the ref form.

### Bounds vs Frame vs Bounding Box

Bounds is origin and size within object’s own viewport.
Frame is origin and size within object’s containing viewport.
Bounding Box is smallest rectangle that contains all of object within object’s containing viewport.

## Optionals

Returning ? implies that nil and non-nil are expected
Returning ! implies that nil is an error.

? properties imply that nil is valid
! properties imply that nil is not valid, but the property is only optional to satisfy initialization order constraints. ! properties should be set to non-nil as soon as possible.

! parameters are invalid
! variables are valid only to satisfy specific ordering conditions. ! variables should be set to non-nil as soon as possible.

## Asserts

Use them as much as possible. They’ll be dead stripped in release builds.

## Errors

Llamakit’s “result” type is nice. Should steal that in the future.

## Properties

Where possible properties should be readonly. Configuration of the state of an object should only happen in the init() methods.

Code in extensions cannot add properties - if the functionality truly belongs in an extension (i.e. is not core to the object’s functionality) you may want to consider adding the functionality via another technique (subclassing, encapsulation, etc).

## Structs vs Classes

Lightweight objects should generally be structs. Structs are always copied (on write?) so should be relatively small.
If you need to keep a pointer to something you need a class (e.g. graph of nodes)
It’s ok to make a lightweight struct and wrap it in a class as needed.
