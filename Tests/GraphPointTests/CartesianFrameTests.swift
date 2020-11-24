import XCTest
@testable import GraphPoint

class CartesianFrameTests: XCTestCase {
    
    static var allTests = [
        ("testMakeForPoints", testMakeForPoints),
        ("testMakeForPointPointRadius", testMakeForPointPointRadius),
    ]
    
    func testMakeForPoints() {
        var point1 = CartesianPoint(x: -10, y: 10)
        var point2 = CartesianPoint(x: 10, y: 10)
        var point3 = CartesianPoint(x: -10, y: -10)
        var point4 = CartesianPoint(x: 10, y: -10)
        
        var frame = CartesianFrame.make(for: [point1, point2, point3, point4])
        XCTAssertEqual(frame.origin.x, -10)
        XCTAssertEqual(frame.origin.y, 10)
        XCTAssertEqual(frame.size.width, 20)
        XCTAssertEqual(frame.size.height, 20)
        
        point1 = CartesianPoint(x: -10, y: 10)
        point2 = CartesianPoint(x: 50, y: 40)
        point3 = CartesianPoint(x: -1, y: -1)
        point4 = CartesianPoint(x: 12, y: -75)
        
        frame = CartesianFrame.make(for: [point1, point2, point3, point4])
        XCTAssertEqual(frame.origin.x, -10)
        XCTAssertEqual(frame.origin.y, 40)
        XCTAssertEqual(frame.size.width, 60)
        XCTAssertEqual(frame.size.height, 115)
    }
    
    func testMakeForPointPointRadius() throws {
        let radius = Radius(15)
        
        // .I > .IV
        var point1 = CartesianPoint(x: 10, y: 10)
        var point2 = CartesianPoint(x: 10, y: -10)
        var frame = try CartesianFrame.make(for: point1, point2: point2, radius: radius)
        XCTAssertEqual(frame.origin.x, 10)
        XCTAssertEqual(frame.origin.y, 10)
        XCTAssertEqual(frame.size.width, 5)
        XCTAssertEqual(frame.size.height, 20)
        
        // .IV > .I
        point1 = CartesianPoint(x: 5, y: -10)
        point2 = CartesianPoint(x: 7, y: 4)
        frame = try CartesianFrame.make(for: point1, point2: point2, radius: radius)
        XCTAssertEqual(frame.origin.x, 5)
        XCTAssertEqual(frame.origin.y, 4)
        XCTAssertEqual(frame.size.width, 10)
        XCTAssertEqual(frame.size.height, 14)
        
        // .II > .I
        point1 = CartesianPoint(x: -10, y: 10)
        point2 = CartesianPoint(x: 10, y: 10)
        frame = try CartesianFrame.make(for: point1, point2: point2, radius: radius)
        XCTAssertEqual(frame.origin.x, -10)
        XCTAssertEqual(frame.origin.y, 15)
        XCTAssertEqual(frame.size.width, 20)
        XCTAssertEqual(frame.size.height, 5)
        
        // .I > .II
        point1 = CartesianPoint(x: 6, y: 2)
        point2 = CartesianPoint(x: -7, y: 14)
        frame = try CartesianFrame.make(for: point1, point2: point2, radius: radius)
        XCTAssertEqual(frame.origin.x, -7)
        XCTAssertEqual(frame.origin.y, 15)
        XCTAssertEqual(frame.size.width, 13)
        XCTAssertEqual(frame.size.height, 13)
        
        // .II > .III
        point1 = CartesianPoint(x: -10, y: 10)
        point2 = CartesianPoint(x: -10, y: -10)
        frame = try CartesianFrame.make(for: point1, point2: point2, radius: radius)
        XCTAssertEqual(frame.origin.x, -15)
        XCTAssertEqual(frame.origin.y, 10)
        XCTAssertEqual(frame.size.width, 5)
        XCTAssertEqual(frame.size.height, 20)
        
        // .III > .II
        point1 = CartesianPoint(x: -1, y: -12)
        point2 = CartesianPoint(x: -14, y: 8)
        frame = try CartesianFrame.make(for: point1, point2: point2, radius: radius)
        XCTAssertEqual(frame.origin.x, -15)
        XCTAssertEqual(frame.origin.y, 8)
        XCTAssertEqual(frame.size.width, 14)
        XCTAssertEqual(frame.size.height, 20)
        
        // .III > .IV
        point1 = CartesianPoint(x: -10, y: -10)
        point2 = CartesianPoint(x: 10, y: -10)
        frame = try CartesianFrame.make(for: point1, point2: point2, radius: radius)
        XCTAssertEqual(frame.origin.x, -10)
        XCTAssertEqual(frame.origin.y, -10)
        XCTAssertEqual(frame.size.width, 20)
        XCTAssertEqual(frame.size.height, 5)
        
        // .IV > .III
        point1 = CartesianPoint(x: 6, y: -4)
        point2 = CartesianPoint(x: -6, y: -8)
        frame = try CartesianFrame.make(for: point1, point2: point2, radius: radius)
        XCTAssertEqual(frame.origin.x, -6)
        XCTAssertEqual(frame.origin.y, -4)
        XCTAssertEqual(frame.size.width, 12)
        XCTAssertEqual(frame.size.height, 11)
        
        // .I > .I
        point1 = CartesianPoint(x: 3, y: 6)
        point2 = CartesianPoint(x: 6, y: 3)
        frame = try CartesianFrame.make(for: point1, point2: point2, radius: radius)
        XCTAssertEqual(frame.origin.x, 3)
        XCTAssertEqual(frame.origin.y, 6)
        XCTAssertEqual(frame.size.width, 3)
        XCTAssertEqual(frame.size.height, 3)
        
        // .I > .III
        point1 = CartesianPoint(x: 6, y: 6)
        point2 = CartesianPoint(x: -6, y: -6)
        
        do {
            frame = try CartesianFrame.make(for: point1, point2: point2, radius: radius)
        } catch GraphPointError.unhandledQuadrantTransition(let q1, let q2) {
            XCTAssertEqual(q1, .I)
            XCTAssertEqual(q2, .III)
        } catch {
            throw error
        }
    }
}
