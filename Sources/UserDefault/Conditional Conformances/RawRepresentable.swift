import Foundation

public extension DefaultsValueConvertible where
	Self: RawRepresentable, RawValue: DefaultsValueConvertible,
	DefaultsRepresentation == RawValue.DefaultsRepresentation
{
	init(defaultsRepresentation: DefaultsRepresentation) throws {
		let raw = try RawValue.init(defaultsRepresentation: defaultsRepresentation)
		guard let value = Self.init(rawValue: raw) else {
			throw DefaultsError.illegalValue(found: defaultsRepresentation, for: Self.self)
		}
		self = value
	}
	
	func defaultsRepresentation() throws -> DefaultsRepresentation {
		return try rawValue.defaultsRepresentation()
	}
}
