import XCTest
@testable import UserDefault

final class PropertyWrapperTests: Tests {
	static var allTests = [
		("properties", testProperties),
	]
	
	@UserDefault("property")
	var propertyTest: String
	@UserDefault("propertyWithDefault")
	var propertyWithDefaultTest: String = "asdf"
	
	@UserDefault("optionalProperty")
	var optionalPropertyTest: String?
	@UserDefault("optionalPropertyWithDefault")
	var optionalPropertyWithDefaultTest: String? = "asdf"
	
	@UserDefault("property2", defaults: .standard)
	var propertyTest2: String
	@UserDefault("propertyWithDefault2", defaults: .standard)
	var propertyWithDefaultTest2: String = "asdf"
	
	@UserDefault("optionalProperty2", defaults: .standard)
	var optionalPropertyTest2: String?
	@UserDefault("optionalPropertyWithDefault2", defaults: .standard)
	var optionalPropertyWithDefaultTest2: String? = "asdf"
	
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
