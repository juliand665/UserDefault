import XCTest
@testable import UserDefault

final class SimpleTests: Tests {
	static var allTests = [
		("optional", testOptional),
		("removing optional", testRemovingOptional),
		("codable", testCodable),
		("optional codable", testOptionalCodable),
		("string array", testStringArray),
		("string convertible array", testStringConvertibleArray),
		("string convertible-ish array", testStringConvertibleishArray),
		("dictionary", testDictionary),
		("dict dict array", testDictDictArray),
		("not an array", testNotAnArray),
		("set", testSet),
		("nscoding", testNSCoding),
	]
	
	func testOptional() {
		saveAndLoad("asdf", defaultValue: nil)
	}
	
	func testRemovingOptional() {
		saveAndLoad(nil, defaultValue: "asdf")
	}
	
	func testCodable() {
		saveAndLoad(CodableStruct(foo: "asdf"), defaultValue: CodableStruct(foo: "initial"))
	}
	
	func testOptionalCodable() {
		saveAndLoad(CodableStruct(foo: "asdf"), defaultValue: nil)
	}
	
	func testStringArray() {
		saveAndLoad(["asdf", "jklö"], defaultValue: [])
	}
	
	func testStringConvertibleArray() {
		saveAndLoad([Stringy.asdf, .jklö], defaultValue: [])
	}
	
	func testStringConvertibleishArray() {
		saveAndLoad([SlightlyLessStringy(stringy: .asdf), SlightlyLessStringy(stringy: .jklö)], defaultValue: [])
	}
	
	func testDictionary() {
		let dict = [
			Stringy.asdf: CodableStruct(foo: "asdf"),
			Stringy.jklö: CodableStruct(foo: "jklö"),
		]
		saveAndLoad(dict, defaultValue: [Stringy.asdf: CodableStruct(foo: "initial")])
	}
	
	func testDictDictArray() {
		let dict = [
			"asdf": [
				"asdf too": [1, 2, 3]
			]
		]
		saveAndLoad(dict, defaultValue: ["hah": [:]])
	}
	
	func testNotAnArray() {
		let notAnArray = CeciNestPasUnArray(storage: [Stringy.asdf, .jklö, .asdf, .asdf])
		saveAndLoad(notAnArray, defaultValue: CeciNestPasUnArray(storage: [.asdf]))
	}
	
	func testSet() {
		let set: Set = [Stringy.asdf, .jklö, .asdf, .asdf]
		saveAndLoad(set, defaultValue: [.asdf])
	}
	
	func testNSCoding() {
		let color = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
		saveAndLoad(color, defaultValue: #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1))
	}
}

extension NSColor: DefaultsValueConvertible {}
