import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ContainerTests.allTests),
        testCase(EnvironementTests.allTests),
    ]
}
#endif
