import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(UserDefaultTests.allTests),
        testCase(PropertyWrapper.allTests),
    ]
}
#endif
