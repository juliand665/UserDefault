import Foundation

@propertyWrapper public struct UserDefault<Value> where Value: DefaultsValueConvertible {
	public let key: String
	public let defaultValue: Value
	public private(set) var wasLoadedSuccessfully: Bool
	public let defaults: UserDefaults
	
	public var wrappedValue: Value {
		didSet {
			guard wrappedValue.hasChanged(from: oldValue) else { return }
			
			saveValue()
		}
	}
	
	public init(wrappedValue: Value, _ key: String, defaults: UserDefaults) {
		self.key = key
		self.defaults = defaults
		self.defaultValue = wrappedValue
		let loaded = Self.loadValue(from: defaults, forKey: key)
		self.wrappedValue = loaded ?? defaultValue
		self.wasLoadedSuccessfully = loaded != nil
	}
	
	public init(wrappedValue: Value, _ key: String) {
		self.init(wrappedValue: wrappedValue, key, defaults: .standard)
	}
	
	public init(_ key: String, defaults: UserDefaults = .standard) where Value: ExpressibleByNilLiteral {
		self.init(wrappedValue: nil, key)
	}
	
	public mutating func loadValue() {
		let loaded = Self.loadValue(from: defaults, forKey: key)
		wasLoadedSuccessfully = loaded != nil
		guard let loaded else { return }
		wrappedValue = loaded
	}
	
	private static func loadValue(from defaults: UserDefaults, forKey key: String) -> Value? {
		do {
			let raw = try Value.DefaultsRepresentation.init(from: defaults, forKey: key)
			return try Value(defaultsRepresentation: raw)
		} catch DefaultsError.missingValue {
			return nil
		} catch {
			print("could not load value for key '\(key)' due to \(error):")
			dump(error)
			return nil
		}
	}
	
	public func saveValue() {
		do {
			try wrappedValue.defaultsRepresentation().save(to: defaults, forKey: key)
		} catch {
			print("could not save value for key \(key) due to \(error)")
			dump(error)
		}
	}
	
	public mutating func clear() {
		wrappedValue = defaultValue
		defaults.removeObject(forKey: key)
	}
}

extension DefaultsError: CustomStringConvertible {
	public var description: String {
		switch self {
		case let .missingValue(key):
			return "there was no value stored for the key '\(key)'"
		case let .typeMismatch(found, expected):
			return "type mismatch: expected value of type \(expected); found '\(found)'"
		case let .illegalValue(found, type):
			return "invalid stored value: expected valid representation of type \(type); found '\(found)'"
		}
	}
}
