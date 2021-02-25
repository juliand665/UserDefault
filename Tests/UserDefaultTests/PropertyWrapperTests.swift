import XCTest
@testable import UserDefault

final class PropertyWrapperTests: Tests {
	static var allTests = [
		("properties", testProperties),
	]
	
	@UserDefault("propertyWithDefault")
	var propertyWithDefaultTest: String = "asdf"
	@UserDefault("optionalProperty")
	var optionalPropertyTest: String?
	@UserDefault("optionalPropertyWithDefault")
	var optionalPropertyWithDefaultTest: String? = "asdf"
	
	@UserDefault("propertyWithDefault2", defaults: .standard)
	var propertyWithDefaultTest2: String = "asdf"
	@UserDefault("optionalProperty2", defaults: .standard)
	var optionalPropertyTest2: String?
	@UserDefault("optionalPropertyWithDefault2", defaults: .standard)
	var optionalPropertyWithDefaultTest2: String? = "asdf"
	
	func testProperties() {
		dump(defaults.persistentDomain(forName: Bundle.main.bundleIdentifier!))
		
		XCTAssertEqual(propertyWithDefaultTest, "asdf")
		propertyWithDefaultTest = "jklö"
		XCTAssertEqual(propertyWithDefaultTest, "jklö")
		
		XCTAssertNil(optionalPropertyTest)
		optionalPropertyTest = "jklö"
		XCTAssertEqual(optionalPropertyTest, "jklö")
		
		XCTAssertEqual(optionalPropertyWithDefaultTest, "asdf")
		optionalPropertyWithDefaultTest = "jklö"
		XCTAssertEqual(optionalPropertyWithDefaultTest, "jklö")
		
		defaults.persistentDomain(forName: Bundle.main.bundleIdentifier!)!.values
			.forEach { XCTAssert($0 as? String == "jklö" || $0 as? [String] == ["jklö"]) }
	}
}
