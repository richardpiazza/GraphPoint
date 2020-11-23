import XCTest
@testable import GraphPoint

class DegreeTests: XCTestCase {
    
    static var allTests = [
        ("testDegreeToRadian", testDegreeToRadian),
        ("testMakeForPointClockwise", testMakeForPointClockwise),
    ]
    
    func testDegreeToRadian() {
        var radian: Radian = Radian(0.62831853071795862)
        XCTAssertEqual(radian.degrees, Degree(36), accuracy: 0.01)
        
        radian = Radian(3.0455995447301052)
        XCTAssertEqual(radian.degrees, Degree(174.5), accuracy: 0.01)
    }
    
    func testMakeForPointClockwise() {
        XCTFail("Not Implemented")
    }
}
