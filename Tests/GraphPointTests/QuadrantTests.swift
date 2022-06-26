import XCTest
@testable import GraphPoint

class QuadrantTests: XCTestCase {
    
    func testInitDegreeClockwise() throws {
        var degree: Degree
        var quadrant: Quadrant
        
        degree = 10.0
        quadrant = try .init(degree: degree)
        XCTAssertEqual(quadrant, .IV)
        quadrant = try .init(degree: degree, clockwise: false)
        XCTAssertEqual(quadrant, .I)
        
        degree = 100.0
        quadrant = try .init(degree: degree)
        XCTAssertEqual(quadrant, .III)
        quadrant = try .init(degree: degree, clockwise: false)
        XCTAssertEqual(quadrant, .II)
        
        degree = 190.0
        quadrant = try .init(degree: degree)
        XCTAssertEqual(quadrant, .II)
        quadrant = try .init(degree: degree, clockwise: false)
        XCTAssertEqual(quadrant, .III)
        
        degree = 280.0
        quadrant = try .init(degree: degree)
        XCTAssertEqual(quadrant, .I)
        quadrant = try .init(degree: degree, clockwise: false)
        XCTAssertEqual(quadrant, .IV)
        
        degree = 400.0
        do {
            quadrant = try .init(degree: degree)
        } catch GraphPointError.invalidDegree(let d) {
            XCTAssertEqual(d, 400.0)
        } catch {
            throw error
        }
    }
    
    func testInitCartesianPoint() {
        var point: CartesianPoint
        var quadrant: Quadrant
        
        point = .zero
        quadrant = .init(cartesianPoint: point)
        XCTAssertEqual(quadrant, .I)
        
        point = .init(x: 40, y: 40)
        quadrant = .init(cartesianPoint: point)
        XCTAssertEqual(quadrant, .I)
        
        point = .init(x: -50, y: 60)
        quadrant = .init(cartesianPoint: point)
        XCTAssertEqual(quadrant, .II)
        
        point = .init(x: -25, y: -90)
        quadrant = .init(cartesianPoint: point)
        XCTAssertEqual(quadrant, .III)
        
        point = .init(x: 100, y: -20)
        quadrant = .init(cartesianPoint: point)
        XCTAssertEqual(quadrant, .IV)
        
        point = .init(x: 45, y: 0)
        quadrant = .init(cartesianPoint: point)
        XCTAssertEqual(quadrant, .I)
        
        point = .init(x: 0, y: 45)
        quadrant = .init(cartesianPoint: point)
        XCTAssertEqual(quadrant, .II)
        
        point = .init(x: -45, y: 0)
        quadrant = .init(cartesianPoint: point)
        XCTAssertEqual(quadrant, .III)
        
        point = .init(x: 0, y: -45)
        quadrant = .init(cartesianPoint: point)
        XCTAssertEqual(quadrant, .IV)
    }
}
