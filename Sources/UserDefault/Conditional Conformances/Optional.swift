import Foundation

extension Optional: DefaultsValueConvertible where Wrapped: DefaultsValueConvertible {
	public typealias DefaultsRepresentation = [Wrapped.DefaultsRepresentation]
	
	public init(defaultsRepresentation: DefaultsRepresentation) throws {
		guard defaultsRepresentation.count < 2 else {
			// not a very helpful error here
			throw DefaultsError.typeMismatch(found: defaultsRepresentation, expected: DefaultsRepresentation.self)
		}
		
		self = try defaultsRepresentation.first.map(Wrapped.init(defaultsRepresentation:))
	}
	
	public func defaultsRepresentation() throws -> [Wrapped.DefaultsRepresentation] {
		return try self.map { [try $0.defaultsRepresentation()] } ?? []
	}
}
