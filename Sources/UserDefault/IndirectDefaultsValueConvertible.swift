// Created by Julian Dunskus

import Foundation

// heavily WIP; trying to preserve information about the defaults representation whenever possible

public protocol IndirectDefaultsValueConvertible: DefaultsStorable {
	associatedtype DefaultsRepresentation: DefaultsStorable
	
	init(defaultsRepresentation: DefaultsRepresentation) throws
	
	func defaultsRepresentation() throws -> DefaultsRepresentation
	
	func defaultsValue() throws -> DefaultsValue
}

public protocol DirectDefaultsValueConvertible: IndirectDefaultsValueConvertible where DefaultsRepresentation: DefaultsValue {}

public extension IndirectDefaultsValueConvertible where Self: DirectDefaultsValueConvertible {
	func defaultsValue() throws -> DefaultsValue {
		return try defaultsRepresentation()
	}
}

/**
```
public extension IndirectDefaultsValueConvertible {
	func save(to defaults: UserDefaults, forKey key: String) throws {
		try encode().save(to: defaults, forKey: key)
	}
	
	static func load(from defaults: UserDefaults, forKey key: String) throws -> Self {
		return try decodeValue(from: try DefaultsRepresentation.load(from: defaults, forKey: key))
	}
}
```
*/
