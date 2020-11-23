import XCTest
@testable import GraphPoint

class RadianTests: XCTestCase {
    
    static var allTests = [
        ("testRadianToDegree", testRadianToDegree),
    ]
    
    func testRadianToDegree() {
        var degree: Degree = Degree(36)
        XCTAssertEqual(degree.radians, Radian(0.62831853071795862))
        
        degree = Degree(174.5)
        XCTAssertEqual(degree.radians, Radian(3.0455995447301052))
    }
}
