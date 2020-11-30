import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(CartesianFrameTests.allTests),
        testCase(CartesianPlaneTests.allTests),
        testCase(CartesianPointTests.allTests),
        testCase(DegreeTests.allTests),
        testCase(QuadrantTests.allTests),
        testCase(RadianTests.allTests),
    ]
}
#endif
