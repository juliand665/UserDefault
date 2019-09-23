import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(FailureTests.allTests),
        testCase(PropertyWrapperTests.allTests),
        testCase(SimpleTests.allTests),
    ]
}
#endif
