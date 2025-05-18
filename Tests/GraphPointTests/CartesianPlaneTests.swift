@testable import GraphPoint
import Swift2D
import XCTest

class CartesianPlaneTests: XCTestCase {

    func testCartesianOrigin() {
        var plane = CartesianPlane(size: Size(width: 40, height: 20))
        XCTAssertEqual(plane.cartesianOrigin.x, 20)
        XCTAssertEqual(plane.cartesianOrigin.y, 10)

        plane = CartesianPlane(axis: 6)
        XCTAssertEqual(plane.cartesianOrigin.x, 6)
        XCTAssertEqual(plane.cartesianOrigin.y, 6)

        plane = CartesianPlane(radius: 45.0)
        XCTAssertEqual(plane.cartesianOrigin.x, 45.0)
        XCTAssertEqual(plane.cartesianOrigin.y, 45.0)
    }

    func testMinimumAxis() {
        var plane = CartesianPlane(size: Size(width: 40, height: 20))
        XCTAssertEqual(plane.minimumAxis, 10)

        plane = CartesianPlane(axis: 6)
        XCTAssertEqual(plane.minimumAxis, 6)

        plane = CartesianPlane(radius: 45.0)
        XCTAssertEqual(plane.minimumAxis, 45.0)
    }

    func testMaximumAxis() {
        var plane = CartesianPlane(size: Size(width: 40, height: 20))
        XCTAssertEqual(plane.maximumAxis, 20)

        plane = CartesianPlane(axis: 6)
        XCTAssertEqual(plane.maximumAxis, 6)

        plane = CartesianPlane(radius: 45.0)
        XCTAssertEqual(plane.maximumAxis, 45.0)
    }

    func testCartesianPointForPoint() {
        // 100 x 100 rect {50 x 50} axes
        let plane = CartesianPlane(radius: 50)

        var point: Point
        var cartesianPoint: CartesianPoint

        point = .init(x: 20, y: 35)
        cartesianPoint = plane.cartesianPoint(for: point)
        XCTAssertEqual(cartesianPoint.x, -30)
        XCTAssertEqual(cartesianPoint.y, 15)

        point = .init(x: 80, y: 35)
        cartesianPoint = plane.cartesianPoint(for: point)
        XCTAssertEqual(cartesianPoint.x, 30)
        XCTAssertEqual(cartesianPoint.y, 15)

        point = .init(x: 20, y: 80)
        cartesianPoint = plane.cartesianPoint(for: point)
        XCTAssertEqual(cartesianPoint.x, -30)
        XCTAssertEqual(cartesianPoint.y, -30)

        point = .init(x: 80, y: 80)
        cartesianPoint = plane.cartesianPoint(for: point)
        XCTAssertEqual(cartesianPoint.x, 30)
        XCTAssertEqual(cartesianPoint.y, -30)
    }

    func testPointForCartesianPoint() {
        // 100 x 100 rect {50 x 50} axes
        let plane = CartesianPlane(radius: 50)

        var cartesianPoint: CartesianPoint
        var point: Point

        cartesianPoint = .init(x: -30, y: 15)
        point = plane.point(for: cartesianPoint)
        XCTAssertEqual(point.x, 20)
        XCTAssertEqual(point.y, 35)

        cartesianPoint = .init(x: 30, y: 15)
        point = plane.point(for: cartesianPoint)
        XCTAssertEqual(point.x, 80)
        XCTAssertEqual(point.y, 35)

        cartesianPoint = .init(x: -30, y: -30)
        point = plane.point(for: cartesianPoint)
        XCTAssertEqual(point.x, 20)
        XCTAssertEqual(point.y, 80)

        cartesianPoint = .init(x: 30, y: -30)
        point = plane.point(for: cartesianPoint)
        XCTAssertEqual(point.x, 80)
        XCTAssertEqual(point.y, 80)
    }

    func testRectForCartesianFrame() {
        // 100 x 100 rect {50 x 50} axes
        let plane = CartesianPlane(radius: 50)
        // {-25, 25}, {50, 50}
        let cartesianFrame = CartesianFrame(origin: .init(x: -25, y: 25), size: .init(width: 50, height: 50))
        let rect = plane.rect(for: cartesianFrame)
        XCTAssertEqual(rect.x, 25)
        XCTAssertEqual(rect.y, 25)
        XCTAssertEqual(rect.width, 50)
        XCTAssertEqual(rect.height, 50)
    }
}
