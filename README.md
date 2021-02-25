<p align="center">
	<a href="https://swift.org/package-manager/">
		<img alt="Swift Package Manager compatible" src="https://img.shields.io/badge/swift_package_manager-compatible-brightgreen.svg" />
	</a>
	<a href="./LICENSE">
		<img alt="MIT licensed" src="https://img.shields.io/badge/license-MIT-blue.svg" />
	</a>
</p>

# UserDefault

###### An overengineered property wrapper interface for `UserDefaults`.

This package started out as trying to write a property wrapper for accessing `UserDefaults`. However, it quickly grew beyond that as I wanted to avoid all the overhead of working with types that aren't directly property list convertible.

### Example

#### Direct Storage

```swift
@UserDefault("hasSeenSplashScreen") var hasSeenSplashScreen = false
@UserDefault("name") var name: String?
@UserDefault("count") var count: Int? = 42

hasSeenSplashScreen = true
name = "John Appleseed"
count = nil
```

#### Codable/NSCoding

There's a protocol extensions for `Codable` that lets you avoid having to write that boilerplate yourself:

```swift
struct CodableStruct {
	var foo: String
}

extension CodableStruct: Equatable, Codable, DefaultsValueConvertible {}

@UserDefault("test") var test = CodableStruct(foo: "hello, world!")
test.foo = "goodbye."
```

As well as for `NSCoding`:

```swift
extension UIColor: DefaultsValueConvertible {}
@UserDefault("color") var color = UIColor.systemRed
color = .systemBlue
```

#### Further Conditional Conformances

I won't go into detail here, but there are also conditional conformances for `Array`, `Dictionary`, `Collection`, `Optional`, and `RawRepresentable` (making it easy to use enums). The goal is to cover all sensible cases in the standard library, so if you find something missing, please open an issue or PR!

#### Custom Conformance

You can either work directly with plist-compatible values:

```swift
struct Convertible {
	var name: String
}

extension Convertible: DefaultsValueConvertible {
	typealias DefaultsRepresentation = String
	
	init(defaultsRepresentation: String) throws {
		name = defaultsRepresentation
	}
	
	func defaultsRepresentation() throws -> String {
		name
	}
}
```

Or delegate that stuff to another type that conforms to `DefaultsValueConvertible`:

```swift
struct IndirectConvertible {
	var name: String
}

extension IndirectConvertible: IndirectDefaultsValueConvertible {
	typealias DefaultsRepresentation = Convertible.DefaultsRepresentation
	
	init(indirectRepresentation: Convertible) throws {
		name = indirectRepresentation.name
	}
	
	func indirectRepresentation() throws -> Convertible {
		try .init(defaultsRepresentation: name)
	}
}
```

### Protocol Hierarchy

Plist-compatible types (like `Bool`, `Data`, `String`, etc.) conform to the `DefaultsValue` protocol, which establishes encoding to and from `UserDefaults`.

The `@UserDefault` property wrapper works with any type conforming to `DefaultsValueConvertible`, which encodes to and from an associated type that conforms to `DefaultsValue`, which is in turn stored in and loaded from the defaults. (`DefaultsValue` itself also conforms to this protocol so you can use it with the wrapper.)

If you'd like to delegate to another `DefaultsValueConvertible` type rather than working directly with plist-compatible types, you can instead conform to `IndirectDefaultsValueConvertible` (which inherits from the former), allowing you to encode to and from any `DefaultsValueConvertible` type. What this means is that you can have arbitrarily long chains of en-/decoding delegation with minimal boilerplate.

If you're working with a sequence-ish type, your best bet is probably to conform to `ExpressibleByArray` or `ExpressibleBySequence`, which will allow you to avoid the boilerplate of mapping your elements to/from their defaults representation provided you have a way to initialize yourself from an `Array` or any `Sequence`, respectively.