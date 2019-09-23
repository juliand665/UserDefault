import Foundation

extension Optional: DefaultsValueConvertible where Wrapped: DefaultsValueConvertible {
	public typealias DefaultsRepresentation = [Wrapped.DefaultsRepresentation]
	
	public init(defaultsRepresentation: DefaultsRepresentation) throws {
		guard defaultsRepresentation.count < 2 else {
			throw DefaultsError.illegalValue(found: defaultsRepresentation, for: Self.self)
		}
		
		self = try defaultsRepresentation.first.map(Wrapped.init(defaultsRepresentation:))
	}
	
	public func defaultsRepresentation() throws -> [Wrapped.DefaultsRepresentation] {
		try self.map { [try $0.defaultsRepresentation()] } ?? []
	}
}
