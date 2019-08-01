import Foundation

public protocol IndirectDefaultsValueConvertible: DefaultsValueConvertible where
	DefaultsRepresentation == IndirectRepresentation.DefaultsRepresentation
{
	associatedtype IndirectRepresentation: DefaultsValueConvertible
	
	init(indirectRepresentation: IndirectRepresentation) throws
	
	func indirectRepresentation() throws -> IndirectRepresentation
}

public extension IndirectDefaultsValueConvertible {
	init(defaultsRepresentation: DefaultsRepresentation) throws {
		try self.init(indirectRepresentation: IndirectRepresentation.init(defaultsRepresentation: defaultsRepresentation))
	}
	
	func defaultsRepresentation() throws -> DefaultsRepresentation {
		return try indirectRepresentation().defaultsRepresentation()
	}
}
