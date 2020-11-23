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
    
    func testRadius() {
        XCTAssertTrue(rect.radius == CGFloat(40))
    }
    
    func testGraphOrigin() {
        let graphOrigin = rect.graphOrigin
        XCTAssertTrue(graphOrigin.x == CGFloat(60))
        XCTAssertTrue(graphOrigin.y == CGFloat(40))
    }
    
    func testPointFromViewPoint() {
        var graphPoint = square.graphPoint(for: CGPoint(x: 20, y: 25))
        XCTAssertEqual(graphPoint.x, CGFloat(-30))
        XCTAssertEqual(graphPoint.y, CGFloat(25))
        
        graphPoint = rect.graphPoint(for: CGPoint(x: 20, y: 25))
        XCTAssertEqual(graphPoint.x, CGFloat(-40))
        XCTAssertEqual(graphPoint.y, CGFloat(15))
    }
    
    func testPointFromGraphPoint() {
        var point = square.point(for: GraphPoint(x: -30, y: 25))
        XCTAssertTrue(point.x == CGFloat(20))
        XCTAssertTrue(point.y == CGFloat(25))
        
        point = rect.point(for: GraphPoint(x: -30, y: 25))
        XCTAssertTrue(point.x == CGFloat(30))
        XCTAssertTrue(point.y == CGFloat(15))
    }
    
    func testPointForDegree() {
        let point = GraphPoint.graphPoint(degree: CGFloat(30), radius: square.radius)
        XCTAssertTrue(round(point.x) == 43.0)
        XCTAssertTrue(round(point.y) == -25.0)
    }
    
    func testDegreeForPoint() {
        let graphPoint = GraphPoint(x: CGFloat(43.301270189222), y: CGFloat(-24.999999999999))
        let degree = GraphPoint.degree(graphPoint: graphPoint)
        XCTAssertTrue(round(degree) == CGFloat(30.0))
    }
    
    func testPointFromGraphPoint2() {
        let rect = CGRect(x: 0.0, y: 0.0, width: 500.0, height: 500.0)
        
        let gp1 = GraphPoint(x: 47.7022488441362, y: -47.7022488441362)
        let t1 = rect.point(for: gp1)
        
        XCTAssertTrue(t1.x == 297.70224884413619)
        XCTAssertTrue(t1.y == 297.70224884413619)
        
        let gp2 = GraphPoint(x: -47.7022488441362, y: -47.7022488441362)
        let t2 = rect.point(for: gp2)
        XCTAssertTrue((t2.x - 202.2977) < 0.0001)
        XCTAssertTrue(t2.y == 297.70224884413619)
        
        let gp3 = GraphPoint(x: -47.7022488441362, y: 47.7022488441362)
        let t3 = rect.point(for: gp3)
        
        XCTAssertTrue((t3.x - 202.2977) < 0.0001)
        XCTAssertTrue((t3.y - 202.2977) < 0.0001)
        
        let gp4 = GraphPoint(x: 47.7022488441362, y: 47.7022488441362)
        let t4 = rect.point(for: gp4)
        
        XCTAssertTrue(t4.x == 297.70224884413619)
        XCTAssertTrue((t4.y - 202.2977) < 0.0001)
    }
    
    func testBoundedPoint() {
        let graphFrame = GraphFrame(x: 47.7022488441362, y: 250.0, width: 197.70454701777979, height: 202.29775115586381)
        let graphPoint = GraphPoint(x: 47.7022488441362, y: 47.7022488441362)
        
        let point = graphFrame.boundedPoint(graphPoint: graphPoint)
        
        XCTAssertTrue(point.x == 0.0)
        XCTAssertTrue((point.y - 202.2977) < 0.0001)
    }
}
