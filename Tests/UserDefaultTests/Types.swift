@testable import UserDefault

struct CodableStruct {
	var foo: String
}

extension CodableStruct: Equatable, Codable, DefaultsValueConvertible {}

enum Stringy: String, DefaultsValueConvertible {
	case asdf
	case jklö
	
	typealias DefaultsRepresentation = String
}

struct SlightlyLessStringy: Equatable {
	var stringy: Stringy
}

extension SlightlyLessStringy: IndirectDefaultsValueConvertible {
	typealias DefaultsRepresentation = Stringy.DefaultsRepresentation
	typealias IndirectRepresentation = Stringy
	
	init(indirectRepresentation: Stringy) throws {
		self.init(stringy: indirectRepresentation)
	}
	
	func indirectRepresentation() throws -> Stringy {
		return stringy
	}
}

struct CeciNestPasUnArray<Element> {
	var storage: [Element]
}

extension CeciNestPasUnArray: Equatable where Element: Equatable {}

extension CeciNestPasUnArray: IndirectDefaultsValueConvertible, DefaultsValueConvertible where
	Element: DefaultsValueConvertible
{
	typealias DefaultsRepresentation = [Element.DefaultsRepresentation]
	typealias IndirectRepresentation = [Element]
	
	init(indirectRepresentation: IndirectRepresentation) throws {
		storage = indirectRepresentation
	}
	
	func indirectRepresentation() throws -> IndirectRepresentation {
		return storage
	}
}
