import Foundation

public protocol ExpressibleByArray: Sequence {
	associatedtype Element
	
	init(array: [Element])
}

public protocol ExpressibleBySequence: ExpressibleByArray {
	init<S>(_ sequence: S) where S: Sequence, S.Element == Element
}

public extension ExpressibleBySequence {
	init(array: [Element]) {
		self.init(array)
	}
}

extension DefaultsValueConvertible where
	Self: ExpressibleByArray, Element: DefaultsValueConvertible
{
	public init(defaultsRepresentation: [Element.DefaultsRepresentation]) throws {
		self.init(array: try defaultsRepresentation.map(Element.init(defaultsRepresentation:)))
	}
	
	public func defaultsRepresentation() throws -> [Element.DefaultsRepresentation] {
		try self.map { try $0.defaultsRepresentation() }
	}
}

extension Set: ExpressibleBySequence {}
extension Set: DefaultsValueConvertible where Element: DefaultsValueConvertible {
	public typealias DefaultsRepresentation = [Element.DefaultsRepresentation]
}
