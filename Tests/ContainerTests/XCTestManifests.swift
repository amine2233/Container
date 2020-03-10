import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ContainerTests.allTests),
        testCase(SettingsTests.allTests),
    ]
}
#endif
