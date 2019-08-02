import XCTest
@testable import UserDefault

final class FailureTests: Tests {
	static var allTests = [
		("type mismatch", testTypeMismatch),
		("illegal stringy value", testIllegalStringyValue),
		("illegal optional value", testIllegalOptionalValue),
		("other error", testOtherError),
		("reset", testReset),
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
	
	func testIllegalStringyValue() {
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
	
	func testIllegalOptionalValue() {
		do {
			var array = UserDefault(key: testKey, defaultValue: ["initial"])
			array.wrappedValue = ["one", "two"] // too many for optional
		}
		
		do {
			let optional = UserDefault<String?>(key: testKey)
			XCTAssertNil(optional.wrappedValue)
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
	
	func testReset() {
		do {
			var optional = UserDefault<String?>(key: testKey)
			XCTAssertNil(optional.wrappedValue)
			optional.wrappedValue = "asdf"
		}
		
		do {
			var optional = UserDefault<String?>(key: testKey)
			XCTAssertEqual(optional.wrappedValue, "asdf")
			optional.clear()
		}
		
		do {
			print(try [String].init(from: defaults, forKey: testKey))
			XCTFail("this call should fail!")
		} catch {
			switch error {
			case DefaultsError.missingValue(testKey):
				print(error)
			default:
				XCTFail("this call should only result in a missing value error")
			}
		}
	}
	
	func testSavingError() {
		let initial = BadEncoder(foo: 42)
		
		do {
			var foo = UserDefault<BadEncoder>(key: testKey, defaultValue: initial)
			foo.wrappedValue = BadEncoder(foo: -1)
		}
		
		do {
			let foo = UserDefault<BadEncoder>(key: testKey, defaultValue: initial)
			XCTAssertEqual(foo.wrappedValue, initial)
		}
	}
}

private struct BadEncoder: Equatable {
	var foo: Int
}

extension BadEncoder: Codable, DefaultsValueConvertible {
	func encode(to encoder: Encoder) throws {
		throw BadError()
	}
}

private struct BadError: Error {}
