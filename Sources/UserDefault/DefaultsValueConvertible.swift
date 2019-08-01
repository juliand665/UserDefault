import Foundation

/// A value that can be converted to/from a 
public protocol DefaultsValueConvertible {
	/// The type used to represent objects of this type in a way that is compatible with user defaults' property list format.
	associatedtype DefaultsRepresentation: DefaultsValue
	
	/// Converts from the defaults plist representation to this type.
	init(defaultsRepresentation: DefaultsRepresentation) throws
	
	/// Converts from this type to the defaults plist representation.
	func defaultsRepresentation() throws -> DefaultsRepresentation
	
	/// A new value is only written back to the defaults if this method returns `true` when comparing to the existing value.
	func hasChanged(from previous: Self) -> Bool
}

public extension DefaultsValueConvertible {
	func hasChanged(from previous: Self) -> Bool {
		return true
	}
}

public extension DefaultsValueConvertible where Self: Equatable {
	func hasChanged(from previous: Self) -> Bool {
		return previous != self
	}
}
