import Foundation

/// You probably don't want to conform to this protocol; it's only for types that can be stored and loaded directly to `UserDefaults` with `saveObject` and `loadObject`, like `Bool`, `Int`, etc.
public protocol DefaultsValue: DefaultsValueConvertible {
	func save(to defaults: UserDefaults, forKey key: String) throws
	init(from defaults: UserDefaults, forKey key: String) throws
}

public extension DefaultsValue {
	init(from defaults: UserDefaults, forKey key: String) throws {
		if let value = defaults.object(forKey: key) {
			self = try value as? Self ??? DefaultsError.typeMismatch(found: value, expected: Self.self)
		} else {
			throw DefaultsError.missingValue(key: key)
		}
	}
	
	init(defaultsRepresentation: Self) throws {
		self = defaultsRepresentation
	}
	
	func defaultsRepresentation() throws -> Self { self }
	
	func save(to defaults: UserDefaults, forKey key: String) throws {
		defaults.set(self, forKey: key)
	}
}

public enum DefaultsError: Error {
	case typeMismatch(found: Any, expected: Any.Type)
	case illegalValue(found: Any, for: Any.Type)
	case missingValue(key: String)
}

// work around swift's weird rules for protocol inheritance × conditional conformance
typealias DirectStorable = DefaultsValue & DefaultsValueConvertible

extension Bool: DirectStorable {}
extension Int: DirectStorable {}
extension String: DirectStorable {}
extension Data: DirectStorable {}
extension Date: DirectStorable {}

// Array/Dictionary are in their own files, along with the conditional conformance.
