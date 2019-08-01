import XCTest
@testable import UserDefault

let defaults = UserDefaults.standard
let testKey = "test"

class Tests: XCTestCase {
	override func setUp() {
		super.setUp()
		
		defaults.setPersistentDomain([:], forName: Bundle.main.bundleIdentifier!)
	}
}

func saveAndLoad<T>(_ value: T, defaultValue: T) where T: DefaultsValueConvertible & Equatable {
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
