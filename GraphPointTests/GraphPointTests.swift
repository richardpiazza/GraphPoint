import XCTest
@testable import GraphPoint

class GraphPointTests: XCTestCase {
    
    let rect = CGRect(x: 0, y: 0, width: 120, height: 80)
    let square = CGRect(x: 0, y: 0, width: 100, height: 100)
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testToRadians() {
        let degree1 = CGFloat(36)
        XCTAssertTrue(degree1.radians == CGFloat(0.62831853071795862))
        
        let degree2 = CGFloat(174.5)
        XCTAssertTrue(degree2.radians == CGFloat(3.0455995447301052))
    }
    
    func testToDegrees() {
        let radians1 = CGFloat(0.62831853071795862)
        XCTAssertTrue(radians1.degrees == CGFloat(36))
        
        let radians2 = CGFloat(3.0455995447301052)
        XCTAssertTrue(radians2.degrees == CGFloat(174.5))
    }
    
    func testRadius() {
        XCTAssertTrue(rect.radius == CGFloat(40))
    }
    
    func testGraphOrigin() {
        let graphOrigin = rect.graphOrigin
        XCTAssertTrue(graphOrigin.x == CGFloat(60))
        XCTAssertTrue(graphOrigin.y == CGFloat(40))
    }
    
    func testPointFromViewPoint() {
        var graphPoint = square.graphPoint(forPoint: CGPoint(x: 20, y: 25))
        XCTAssertTrue(graphPoint.x == CGFloat(-30))
        XCTAssertTrue(graphPoint.y == CGFloat(25))
        
        graphPoint = rect.graphPoint(forPoint: CGPoint(x: 20, y: 25))
        XCTAssertTrue(graphPoint.x == CGFloat(-40))
        XCTAssertTrue(graphPoint.y == CGFloat(15))
    }
    
    func testPointFromGraphPoint() {
        var point = square.point(forGraphPoint: GraphPoint(x: -30, y: 25))
        XCTAssertTrue(point.x == CGFloat(20))
        XCTAssertTrue(point.y == CGFloat(25))
        
        point = rect.point(forGraphPoint: GraphPoint(x: -30, y: 25))
        XCTAssertTrue(point.x == CGFloat(30))
        XCTAssertTrue(point.y == CGFloat(15))
    }
    
    func testPointForDegree() {
        let point = square.graphPoint(forDegree: CGFloat(30))
        XCTAssertTrue(point.x == CGFloat(43.301270189221931))
        XCTAssertTrue(point.y == CGFloat(-24.999999999999996))
    }
    
    func testDegreeForPoint() {
        let graphPoint = GraphPoint(x: CGFloat(43.301270189222), y: CGFloat(-24.999999999999))
        let degree = square.degree(forGraphPoint: graphPoint)
        XCTAssertTrue(round(degree) == CGFloat(30.0))
    }
}
