// Created by Julian Dunskus

import Foundation

/// You probably don't want to conform to this protocol; it's only for types that can be stored and loaded directly to `UserDefaults` with `saveObject` and `loadObject`, like `Bool`, `Int`, etc.
public protocol DefaultsValue {}

public extension DefaultsStorable where Self: DefaultsValue {
	func save(to defaults: UserDefaults, forKey key: String) throws {
		defaults.set(self, forKey: key)
	}
	
	init(from defaults: UserDefaults, forKey key: String) throws {
		if let value = defaults.object(forKey: key) {
			self = try value as? Self ??? DefaultsError.typeMismatch(found: value, expected: Self.self)
		} else {
			throw DefaultsError.missingValue
		}
	}
}

// work around swift's weird rules for protocol inheritance × conditional conformance
typealias DirectStorable = DefaultsValue & DefaultsStorable

extension Bool: DirectStorable {}
extension Int: DirectStorable {}
extension String: DirectStorable {}
extension Data: DirectStorable {}
extension Date: DirectStorable {}

extension Array: DirectStorable where Element: DefaultsValue {}

extension Dictionary: DirectStorable where Key == String, Value: DefaultsValue {} // TODO: doesn't key have to be string?


