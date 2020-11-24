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
    
    func testMakeForPointClockwise() throws {
        var point: CartesianPoint
        var degree: Degree
        
        point = .nan
        do {
            degree = try Degree.make(for: point)
        } catch GraphPointError.invalidPoint(let p) {
            XCTAssertEqual(p, .nan)
        } catch {
            throw error
        }
        
        point = .zero
        do {
            degree = try Degree.make(for: point)
        } catch GraphPointError.invalidPoint(let p) {
            XCTAssertEqual(p, .zero)
        } catch {
            throw error
        }
        
        // Quadrant.I (shallow)
        point = .init(x: 20, y: 10)
        degree = try Degree.make(for: point)
        XCTAssertEqual(degree, 333.43494)
        
        degree = try Degree.make(for: point, clockwise: false)
        XCTAssertEqual(degree, 26.565063)
        
        // Quadrant.I (deep)
        point = .init(x: 5, y: 40)
        degree = try Degree.make(for: point)
        XCTAssertEqual(degree, 277.12503)
        
        degree = try Degree.make(for: point, clockwise: false)
        XCTAssertEqual(degree, 82.87497)
        
        // Quadrant.II (shallow)
        point = .init(x: -20, y: 40)
        degree = try Degree.make(for: point)
        XCTAssertEqual(degree, 243.43495)
        
        degree = try Degree.make(for: point, clockwise: false)
        XCTAssertEqual(degree, 116.56505)
        
        // Quadrant.II (deep)
        point = .init(x: -40, y: 20)
        degree = try Degree.make(for: point)
        XCTAssertEqual(degree, 206.56505)
        
        degree = try Degree.make(for: point, clockwise: false)
        XCTAssertEqual(degree, 153.43495)
        
        // Quadrant.III (shallow)
        point = .init(x: -45, y: -10)
        degree = try Degree.make(for: point)
        XCTAssertEqual(degree, 167.47119)
        
        degree = try Degree.make(for: point, clockwise: false)
        XCTAssertEqual(degree, 192.52881)
        
        // Quadrant.III (deep)
        point = .init(x: -10, y: -45)
        degree = try Degree.make(for: point)
        XCTAssertEqual(degree, 102.52881)
        
        degree = try Degree.make(for: point, clockwise: false)
        XCTAssertEqual(degree, 257.4712)
        
        // Quadrant.IV (shallow
        point = .init(x: 224, y: -18)
        degree = try Degree.make(for: point)
        XCTAssertEqual(degree, 4.594246)
        
        degree = try Degree.make(for: point, clockwise: false)
        XCTAssertEqual(degree, 355.40576)
        
        // Quadrant.IV (deep)
        point = .init(x: 18, y: -224)
        degree = try Degree.make(for: point)
        XCTAssertEqual(degree, 85.405754)
        
        degree = try Degree.make(for: point, clockwise: false)
        XCTAssertEqual(degree, 274.59424)
    }
}
