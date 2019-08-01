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
