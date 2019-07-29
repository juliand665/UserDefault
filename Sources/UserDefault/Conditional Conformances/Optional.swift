// Created by Julian Dunskus

import Foundation

// FIXME: this doesn't quite work as intended; ideally, defaults would have a notion of null vs missing
extension Optional: DefaultsStorable where Wrapped: DefaultsStorable {
	public func save(to defaults: UserDefaults, forKey key: String) throws {
		if let value = self {
			try value.save(to: defaults, forKey: key)
		} else {
			defaults.removeObject(forKey: key)
		}
	}
	
	public init(from defaults: UserDefaults, forKey key: String) throws {
		if defaults.hasValue(forKey: key) {
			self = try Wrapped.init(from: defaults, forKey: key)
		} else {
			self = nil
		}
	}
}
