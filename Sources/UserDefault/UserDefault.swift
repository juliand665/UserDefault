import Foundation

@propertyWrapper public struct UserDefault<Value> where Value: DefaultsValueConvertible {
	public let key: String
	public let defaultValue: Value
	
	private let defaults: UserDefaults
	
	public var wrappedValue: Value {
		didSet {
			guard wrappedValue.hasChanged(from: oldValue) else { return }
			
			saveValue()
		}
	}
	
	public init(wrappedValue: Value, _ key: String, defaults: UserDefaults) {
		self.key = key
		self.defaults = .standard
		self.defaultValue = wrappedValue
		
		self.wrappedValue = defaultValue
		loadValue()
	}
	
	public init(wrappedValue: Value, _ key: String) {
		self.init(wrappedValue: wrappedValue, key, defaults: .standard)
	}
	
	public init<T>(_ key: String, defaults: UserDefaults = .standard) where Value == T? {
		self.init(wrappedValue: nil, key)
	}
	
	public mutating func loadValue() {
		do {
			let raw = try Value.DefaultsRepresentation.init(from: defaults, forKey: key)
			wrappedValue = try Value(defaultsRepresentation: raw)
		} catch DefaultsError.missingValue {
			wrappedValue = defaultValue
		} catch {
			print("could not load value for key '\(key)' due to \(error):")
			dump(error)
			print("using default value instead!")
			wrappedValue = defaultValue
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
