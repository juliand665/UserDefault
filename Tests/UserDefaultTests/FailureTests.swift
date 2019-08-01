import XCTest
@testable import UserDefault

final class FailureTests: Tests {
	static var allTests = [
		("type mismatch", testTypeMismatch),
		("illegal value", testIllegalValue),
		("other error", testOtherError),
	]
	
	func testTypeMismatch() {
		do {
			var string = UserDefault(key: testKey, defaultValue: "asdf")
			string.wrappedValue = "jklö"
		}
		
		do {
			var int = UserDefault(key: testKey, defaultValue: 42)
			XCTAssertEqual(int.wrappedValue, 42)
			int.wrappedValue = 18
		}
		
		do {
			var string = UserDefault(key: testKey, defaultValue: "asdf")
			XCTAssertEqual(string.wrappedValue, "asdf")
			string.wrappedValue = "jklö"
		}
	}
	
	func testIllegalValue() {
		do {
			var string = UserDefault(key: testKey, defaultValue: "initial")
			string.wrappedValue = "fghj"
		}
		
		do {
			var stringy = UserDefault(key: testKey, defaultValue: Stringy.asdf)
			XCTAssertEqual(stringy.wrappedValue, .asdf)
			stringy.wrappedValue = .jklö
		}
		
		do {
			let string = UserDefault(key: testKey, defaultValue: "initial")
			XCTAssertEqual(string.wrappedValue, "jklö")
		}
	}
	
	func testOtherError() {
		do {
			var data = UserDefault(key: testKey, defaultValue: Data())
			data.wrappedValue = "asdf".data(using: .utf8)!
		}
		
		do {
			var codable = UserDefault(key: testKey, defaultValue: CodableStruct(foo: "initial"))
			codable.wrappedValue = CodableStruct(foo: "foo value")
		}
		
		do {
			let data = UserDefault(key: testKey, defaultValue: Data())
			// that encoding should definitely be at least 8 bytes long
			XCTAssert(data.wrappedValue.count >= 8)
		}
	}
}
