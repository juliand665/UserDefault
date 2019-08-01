import XCTest
@testable import UserDefault

final class PropertyWrapperTests: Tests {
	static var allTests = [
		("properties", testProperties),
	]
	
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
}
