// Created by Julian Dunskus

import Foundation

public protocol AnyDefaultsStorable {
	func save(to defaults: UserDefaults, forKey key: String) throws
	init(from defaults: UserDefaults, forKey key: String) throws
}

public protocol DiffableDefaultsStorable: AnyDefaultsStorable {
	///  A new value is only written back to the defaults if this method returns `true` when comparing to the existing value.
	func hasChanged(from previous: Self) -> Bool
}

public typealias DefaultsStorable = AnyDefaultsStorable & DiffableDefaultsStorable

public enum DefaultsError: Error {
	case typeMismatch(found: Any, expected: Any.Type)
	case missingValue
}

public extension DiffableDefaultsStorable {
	func hasChanged(from previous: Self) -> Bool {
		return true
	}
}

public extension DiffableDefaultsStorable where Self: Equatable {
	func hasChanged(from previous: Self) -> Bool {
		return previous != self
	}
}

extension UserDefaults {
	func hasValue(forKey key: String) -> Bool {
		return !dictionaryWithValues(forKeys: [key]).isEmpty
	}
	
	func fooValue(forKey key: String) -> Any? {
		let dict = dictionaryWithValues(forKeys: [key])
		assert(dict.count < 2)
		return dict[key]
	}
}
