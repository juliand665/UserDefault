// Created by Julian Dunskus

import Foundation

public extension DefaultsStorable where Self: RawRepresentable, RawValue: DefaultsStorable {
	func save(to defaults: UserDefaults, forKey key: String) throws {
		try rawValue.save(to: defaults, forKey: key)
	}
	
	init(from defaults: UserDefaults, forKey key: String) throws {
		let raw = try RawValue.init(from: defaults, forKey: key)
		guard let value = Self.init(rawValue: raw) else {
			throw DefaultsError.typeMismatch(found: raw, expected: RawValue.self)
		}
		self = value
	}
}
