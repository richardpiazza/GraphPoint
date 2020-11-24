import XCTest
@testable import GraphPoint

class CartesianPointTests: XCTestCase {
    
    static var allTests = [
        ("testMinimumAxis", testMinimumAxis),
        ("testMakeForDegreeRadius", testMakeForDegreeRadius),
        ("testMakeForDegreeRadiusLimiter", testMakeForDegreeRadiusLimiter),
    ]
    
    func testMinimumAxis() {
        var point: CartesianPoint = .init(x: 40, y: 40)
        XCTAssertEqual(point.minimumAxis, 40)
        
        point = .init(x: -50, y: 60)
        XCTAssertEqual(point.minimumAxis, 60)
        
        point = .init(x: -25, y: -90)
        XCTAssertEqual(point.minimumAxis, 90)
        
        point = .init(x: 100, y: -20)
        XCTAssertEqual(point.minimumAxis, 100)
    }
    
    func testMakeForDegreeRadius() throws {
        var point: CartesianPoint
        
        do {
            point = try .make(for: 100.0, degree: -60.0)
        } catch GraphPointError.invalidDegree(let degree) {
            XCTAssertEqual(degree, -60.0)
        } catch {
            throw error
        }
        
        do {
            point = try .make(for: 100.0, degree: 400.0)
        } catch GraphPointError.invalidDegree(let degree) {
            XCTAssertEqual(degree, 400.0)
        } catch {
            throw error
        }
        
        do {
            point = try .make(for: -12.0, degree: 80.0)
        } catch GraphPointError.invalidRadius(let radius) {
            XCTAssertEqual(radius, -12.0)
        } catch {
            throw error
        }
        
        point = try .make(for: 0.0, degree: 0.0)
        XCTAssertEqual(point.x, 0.0)
        XCTAssertEqual(point.y, 0.0)
        
        point = try .make(for: 10, degree: 10.0)
        XCTAssertEqual(point.x, 9.848078)
        XCTAssertEqual(point.y, -1.7364818)
        
        point = try .make(for: 10, degree: 45.0)
        XCTAssertEqual(point.x, 7.071068)
        XCTAssertEqual(point.y, -7.071068)
        
        point = try .make(for: 10, degree: 80.0)
        XCTAssertEqual(point.x, 1.7364818)
        XCTAssertEqual(point.y, -9.848078)
        
        point = try .make(for: 10, degree: 90.0)
        XCTAssertEqual(point.x, 0.0)
        XCTAssertEqual(point.y, -10.0)
        
        point = try .make(for: 10, degree: 100.0)
        XCTAssertEqual(point.x, -1.7364818)
        XCTAssertEqual(point.y, -9.848078)
        
        point = try .make(for: 10, degree: 135.0)
        XCTAssertEqual(point.x, -7.071068)
        XCTAssertEqual(point.y, -7.071068)
        
        point = try .make(for: 10, degree: 170.0)
        XCTAssertEqual(point.x, -9.848078)
        XCTAssertEqual(point.y, -1.7364818)
        
        point = try .make(for: 10, degree: 180.0)
        XCTAssertEqual(point.x, -10.0)
        XCTAssertEqual(point.y, 0.0)
        
        point = try .make(for: 10, degree: 190.0)
        XCTAssertEqual(point.x, -9.848078)
        XCTAssertEqual(point.y, 1.7364818)
        
        point = try .make(for: 10, degree: 225.0)
        XCTAssertEqual(point.x, -7.071068)
        XCTAssertEqual(point.y, 7.071068)
        
        point = try .make(for: 10, degree: 260.0)
        XCTAssertEqual(point.x, -1.7364818)
        XCTAssertEqual(point.y, 9.848078)
        
        point = try .make(for: 10, degree: 270.0)
        XCTAssertEqual(point.x, 0.0)
        XCTAssertEqual(point.y, 10.0)
        
        point = try .make(for: 10, degree: 280.0)
        XCTAssertEqual(point.x, 1.7364818)
        XCTAssertEqual(point.y, 9.848078)
        
        point = try .make(for: 10, degree: 315.0)
        XCTAssertEqual(point.x, 7.071068)
        XCTAssertEqual(point.y, 7.071068)
        
        point = try .make(for: 10, degree: 350.0)
        XCTAssertEqual(point.x, 9.848078)
        XCTAssertEqual(point.y, 1.7364818)
        
        point = try .make(for: 10, degree: 360.0)
        XCTAssertEqual(point.x, 10.0)
        XCTAssertEqual(point.y, 0.0)
    }
    
    func testMakeForDegreeRadiusLimiter() throws {
        var modifier: CartesianPoint = .zero
        var point: CartesianPoint
        
        do {
            point = try .make(for: 100.0, degree: -60.0, modifier: modifier)
        } catch GraphPointError.invalidDegree(let degree) {
            XCTAssertEqual(degree, -60.0)
        } catch {
            throw error
        }
        
        do {
            point = try .make(for: 100.0, degree: 400.0, modifier: modifier)
        } catch GraphPointError.invalidDegree(let degree) {
            XCTAssertEqual(degree, 400.0)
        } catch {
            throw error
        }
        
        do {
            point = try .make(for: -12.0, degree: 80.0, modifier: modifier)
        } catch GraphPointError.invalidRadius(let radius) {
            XCTAssertEqual(radius, -12.0)
        } catch {
            throw error
        }
        
        point = try .make(for: 0.0, degree: 0.0, modifier: modifier)
        XCTAssertEqual(point.x, 0.0)
        XCTAssertEqual(point.y, 0.0)
        
        modifier = .init(x: 0.0, y: 5.0)
        point = try .make(for: 10, degree: 10.0, modifier: modifier)
        XCTAssertEqual(point.x, 8.6602545)
        XCTAssertEqual(point.y, 5.0)
        
        modifier = .init(x: 5.0, y: 0.0)
        point = try .make(for: 10, degree: 45.0, modifier: modifier)
        XCTAssertEqual(point.x, 5.0)
        XCTAssertEqual(point.y, -8.6602545)
        
        modifier = .init(x: 5.0, y: 0.0)
        point = try .make(for: 10, degree: 80.0, modifier: modifier)
        XCTAssertEqual(point.x, 5.0)
        XCTAssertEqual(point.y, -8.6602545)
        
        modifier = .init(x: 5.0, y: 0.0)
        point = try .make(for: 10, degree: 90.0, modifier: modifier)
        XCTAssertEqual(point.x, 5.0)
        XCTAssertEqual(point.y, -8.6602545)
        
        modifier = .init(x: -5.0, y: 0.0)
        point = try .make(for: 10, degree: 100.0, modifier: modifier)
        XCTAssertEqual(point.x, -5.0)
        XCTAssertEqual(point.y, -8.6602545)
        
        modifier = .init(x: 0.0, y: -5.0)
        point = try .make(for: 10, degree: 135.0, modifier: modifier)
        XCTAssertEqual(point.x, -8.6602545)
        XCTAssertEqual(point.y, -5.0)
        
        modifier = .init(x: 0.0, y: -5.0)
        point = try .make(for: 10, degree: 170.0, modifier: modifier)
        XCTAssertEqual(point.x, -8.6602545)
        XCTAssertEqual(point.y, -5.0)
        
        modifier = .init(x: 0.0, y: 5.0)
        point = try .make(for: 10, degree: 180.0, modifier: modifier)
        XCTAssertEqual(point.x, -8.6602545)
        XCTAssertEqual(point.y, 5.0)
        
        modifier = .init(x: 0.0, y: 5.0)
        point = try .make(for: 10, degree: 190.0, modifier: modifier)
        XCTAssertEqual(point.x, -8.6602545)
        XCTAssertEqual(point.y, 5.0)
        
        modifier = .init(x: -5.0, y: 0.0)
        point = try .make(for: 10, degree: 225.0, modifier: modifier)
        XCTAssertEqual(point.x, -5.0)
        XCTAssertEqual(point.y, 8.6602545)
        
        modifier = .init(x: -5.0, y: 0.0)
        point = try .make(for: 10, degree: 260.0, modifier: modifier)
        XCTAssertEqual(point.x, -5.0)
        XCTAssertEqual(point.y, 8.6602545)
        
        modifier = .init(x: 5.0, y: 0.0)
        point = try .make(for: 10, degree: 270.0, modifier: modifier)
        XCTAssertEqual(point.x, 5.0)
        XCTAssertEqual(point.y, 8.6602545)
        
        modifier = .init(x: 5.0, y: 0.0)
        point = try .make(for: 10, degree: 280.0, modifier: modifier)
        XCTAssertEqual(point.x, 5.0)
        XCTAssertEqual(point.y, 8.6602545)
        
        modifier = .init(x: 0.0, y: 5.0)
        point = try .make(for: 10, degree: 315.0, modifier: modifier)
        XCTAssertEqual(point.x, 8.6602545)
        XCTAssertEqual(point.y, 5.0)
        
        modifier = .init(x: 0.0, y: 5.0)
        point = try .make(for: 10, degree: 350.0, modifier: modifier)
        XCTAssertEqual(point.x, 8.6602545)
        XCTAssertEqual(point.y, 5.0)
        
        modifier = .init(x: 0.0, y: 5.0)
        point = try .make(for: 10, degree: 360.0, modifier: modifier)
        XCTAssertEqual(point.x, 8.6602545)
        XCTAssertEqual(point.y, 5.0)
    }
}
