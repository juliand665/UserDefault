import Foundation

@propertyWrapper public struct UserDefault<Value> where Value: DefaultsStorable {
	public let key: String
	
	private let defaults: UserDefaults
	
	public var wrappedValue: Value {
		didSet {
			guard wrappedValue.hasChanged(from: oldValue) else { return }
			
			try! wrappedValue.save(to: defaults, forKey: key)
		}
	}
	
	public init(key: String, defaults: UserDefaults = .standard, defaultValue: Value) {
		self.key = key
		self.defaults = defaults
		do {
			wrappedValue = try Value.init(from: defaults, forKey: key)
		} catch DefaultsError.missingValue {
			wrappedValue = defaultValue
		} catch DefaultsError.typeMismatch(found: let found, expected: let expected) {
			print("could not load value for key \(key) due to a type mismatch (expected value of type \(expected); found \(found)); using default value instead")
			wrappedValue = defaultValue
		} catch {
			dump(error)
			fatalError("could not load value for key \(key) due to \(error)")
		}
	}
	
	public init<T>(key: String, defaults: UserDefaults = .standard) where Value == T? {
		self.init(key: key, defaults: defaults, defaultValue: nil)
	}
}
