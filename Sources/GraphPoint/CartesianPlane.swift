import Foundation
import Swift2D

/// A Cartesian plane is defined by two perpendicular number lines: the x-axis, which is horizontal, and the y-axis,
/// which is vertical. Using these axes, we can describe any point in the plane using an ordered pair of numbers.
///
/// In **GraphPoint** ever rectangle is a cartesian plane with the origin _typically_ at the center.
public typealias CartesianPlane = Rect

public extension CartesianPlane {
    init(axis: Int) {
        self.init(
            size: Size(width: axis * 2, height: axis * 2)
        )
    }

    init(radius: Radius) {
        self.init(
            size: Size(width: radius * 2, height: radius * 2)
        )
    }
}

public extension CartesianPlane {
    /// The point where the axes of the `CartesianPlane` intersect.
    ///
    /// The origin divides each of these axes into two halves, a positive and a negative semi-axis. Points can then be
    /// located with reference to the origin by giving their numerical coordinates—that is, the positions of their
    /// projections along each axis, either in the positive or negative direction. The coordinates of the origin are always
    /// all zero. For example: {0,0}.
    var cartesianOrigin: Point {
        center
    }

    /// The length of the shortest axis found in this plane.
    var minimumAxis: Double {
        min(midX, midY)
    }

    /// The length of the shortest axis found in this plane.
    var maximumAxis: Double {
        max(midX, midY)
    }

    /// Converts a non-cartesian `Point` to a `CartesianPoint`.
    ///
    /// The assumption being made is that the `Point` being provided uses the standard top-left origin indexing for
    /// {0,0}.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let plane = CartesianPlane(size: Size(width: 100, height: 100))
    /// let point = Point(x: 25, y: 25)
    /// let cartesianPoint = plan.cartesianPoint(for: point)
    /// // cartesianPoint == CartesianPoint(x: -25, y: 25)
    /// ```
    ///
    /// - parameters:
    ///   - point: A standard `Point` (which uses top-left as {0, 0}).
    /// - returns A `CartesianPoint` which has been translated onto the _plane_.
    func cartesianPoint(for point: Point) -> CartesianPoint {
        let origin = cartesianOrigin
        var cartesianPoint: CartesianPoint = .zero

        if point.x < origin.x {
            cartesianPoint = cartesianPoint.with(x: -(origin.x - point.x))
        } else if point.x > origin.x {
            cartesianPoint = cartesianPoint.with(x: point.x - origin.x)
        }

        if point.y > origin.y {
            cartesianPoint = cartesianPoint.with(y: -(point.y - origin.y))
        } else if point.y < origin.y {
            cartesianPoint = cartesianPoint.with(y: origin.y - point.y)
        }

        return cartesianPoint
    }

    /// Converts a `CartesianPoint` to a non-cartesian `Point`.
    func point(for cartesianPoint: CartesianPoint) -> Point {
        var point: Point = .zero

        if cartesianPoint.x >= 0.0 {
            point = point.with(x: cartesianOrigin.x + cartesianPoint.x)
        } else {
            point = point.with(x: cartesianOrigin.x - abs(cartesianPoint.x))
        }

        if cartesianPoint.y <= 0.0 {
            point = point.with(y: cartesianOrigin.y + abs(cartesianPoint.y))
        } else {
            point = point.with(y: cartesianOrigin.y - cartesianPoint.y)
        }

        return point
    }

    /// Converts a `CartesianFrame` to a non-cartesian `Rect`.
    func rect(for cartesianFrame: CartesianFrame) -> Rect {
        let origin = cartesianOrigin
        return Rect(origin: Point(x: origin.x + cartesianFrame.origin.x, y: origin.y - cartesianFrame.origin.y), size: cartesianFrame.size)
    }

    /// A `CartesianPoint` within the bounds of the plane for the given `Degree` and `maximumAxis`.
    func cartesianPoint(for degree: Degree, clockwise: Bool = true) throws -> CartesianPoint {
        try CartesianPoint.make(for: maximumAxis, degree: degree, clockwise: clockwise)
    }
}
