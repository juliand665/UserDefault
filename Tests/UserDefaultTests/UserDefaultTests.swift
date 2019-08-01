import XCTest
@testable import UserDefault

let defaults = UserDefaults.standard
let testKey = "test"

final class UserDefaultTests: XCTestCase {	
	static var allTests = [
		("optional", testOptional),
		("removing optional", testRemovingOptional),
		("codable", testCodable),
		("optional codable", testOptionalCodable),
		("properties", testProperties),
	]
	
	override func setUp() {
		super.setUp()
		
		defaults.setPersistentDomain([:], forName: Bundle.main.bundleIdentifier!)
	}
	
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
	
	@UserDefault(key: "property") var propertyTest: String
	@UserDefault(key: "propertyWithDefault", defaultValue: "asdf") var propertyWithDefaultTest: String
	
	@UserDefault(key: "optionalProperty") var optionalPropertyTest: String?
	@UserDefault(key: "optionalPropertyWithDefault", defaultValue: "asdf") var optionalPropertyWithDefaultTest: String?
	
	func testProperties() {
		dump(defaults.persistentDomain(forName: Bundle.main.bundleIdentifier!))
		
		XCTAssertNil(propertyTest)
		propertyTest = "jklö"
		
		XCTAssertEqual(propertyWithDefaultTest, "asdf")
		propertyWithDefaultTest = "jklö"
		
		XCTAssertNil(optionalPropertyTest)
		optionalPropertyTest = "jklö"
		
		XCTAssertEqual(optionalPropertyWithDefaultTest, "asdf")
		optionalPropertyWithDefaultTest = "jklö"
		
		defaults.persistentDomain(forName: Bundle.main.bundleIdentifier!)!.values
			.forEach { XCTAssert($0 as? String == "jklö" || $0 as? [String] == ["jklö"]) }
	}
	
	func testSomething() {
		dump(defaults.dictionaryRepresentation().count)
		defaults.set("asdf", forKey: testKey)
		dump(defaults.dictionaryRepresentation().count)
		defaults.set(nil as String?, forKey: testKey)
		dump(defaults.dictionaryRepresentation().count)
	}
	
	private func saveAndLoad<T>(_ value: T, defaultValue: T) where T: DefaultsValueConvertible & Equatable {
		precondition(value != defaultValue)
		do {
			var wrapper = UserDefault(key: testKey, defaultValue: defaultValue)
			// back and forth a few times to make sure everything works
			wrapper.wrappedValue = value
			wrapper.wrappedValue = defaultValue
			wrapper.wrappedValue = value
		}
		let wrapper = UserDefault(key: testKey, defaultValue: defaultValue)
		XCTAssertEqual(wrapper.wrappedValue, value)
	}
}

struct CodableStruct {
	var foo: String
}

extension CodableStruct: Equatable, Codable, DefaultsValueConvertible {}
