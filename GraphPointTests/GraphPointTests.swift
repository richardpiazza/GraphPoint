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
        XCTAssertTrue(round(point.x) == 43.0)
        XCTAssertTrue(round(point.y) == -25.0)
    }
    
    func testDegreeForPoint() {
        let graphPoint = GraphPoint(x: CGFloat(43.301270189222), y: CGFloat(-24.999999999999))
        let degree = square.degree(forGraphPoint: graphPoint)
        XCTAssertTrue(round(degree) == CGFloat(30.0))
    }
    
    func testPointFromGraphPoint2() {
        let rect = CGRect(x: 0.0, y: 0.0, width: 500.0, height: 500.0)
        
        let gp1 = GraphPoint(x: 47.7022488441362, y: -47.7022488441362)
        let t1 = rect.point(forGraphPoint: gp1)
        
        XCTAssertTrue(t1.x == 297.70224884413619)
        XCTAssertTrue(t1.y == 297.70224884413619)
        
        let gp2 = GraphPoint(x: -47.7022488441362, y: -47.7022488441362)
        let t2 = rect.point(forGraphPoint: gp2)
        XCTAssertTrue(t2.x == 202.29775115586381)
        XCTAssertTrue(t2.y == 297.70224884413619)
        
        let gp3 = GraphPoint(x: -47.7022488441362, y: 47.7022488441362)
        let t3 = rect.point(forGraphPoint: gp3)
        
        XCTAssertTrue(t3.x == 202.29775115586381)
        XCTAssertTrue(t3.y == 202.29775115586381)
        
        let gp4 = GraphPoint(x: 47.7022488441362, y: 47.7022488441362)
        let t4 = rect.point(forGraphPoint: gp4)
        
        XCTAssertTrue(t4.x == 297.70224884413619)
        XCTAssertTrue(t4.y == 202.29775115586381)
    }
}
