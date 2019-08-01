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
}
