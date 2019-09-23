import Foundation

extension Array: DefaultsValue where Element: DefaultsValue {}

extension Array: DefaultsValueConvertible where Element: DefaultsValueConvertible {
	public typealias DefaultsRepresentation = [Element.DefaultsRepresentation]
	
	public init(defaultsRepresentation: DefaultsRepresentation) throws {
		self = try defaultsRepresentation.map(Element.init(defaultsRepresentation:))
	}
	
	public func defaultsRepresentation() throws -> DefaultsRepresentation {
		try self.map { try $0.defaultsRepresentation() }
	}
}
