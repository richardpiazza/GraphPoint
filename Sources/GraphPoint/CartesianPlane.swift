import Foundation
import Swift2D

public typealias CartesianPlane = Rect

public extension CartesianPlane {
    init(size: Size) {
        self.init()
        origin = .zero
        self.size = size
    }
    
    init(radius: Int) {
        self.init()
        origin = .zero
        size = Size(width: radius, height: radius)
    }
    
    init(radius: Float) {
        self.init()
        origin = .zero
        size = Size(width: radius, height: radius)
    }
}

public extension CartesianPlane {
    enum Quadrant: Int {
        case I = 1
        case II = 2
        case III = 3
        case IV = 4
    }
}

public extension CartesianPlane {
    /// The `Point` that represents the {0, 0} origin of the plane.
    var cartesianOrigin: Point {
        return center
    }
    
    /// Converts a non-cartesian `Point` to a `CartesianPoint`.
    ///
    /// This assumes that the `Point` given has an _origin_ based on the top-left of a `Rect`. For example:
    /// ```swift
    /// let plane = CartesianPlane(size: Size(width: 100, height: 100))
    /// let point = Point(x: 25, y: 25)
    /// let cartesianPoint = plan.cartesianPoint(for: point)
    /// // cartesianPoint == CartesianPoint(x: -25, y: 25)
    /// ```
    func cartesianPoint(for point: Point) -> CartesianPoint {
        let origin = cartesianOrigin
        var cartesianPoint: CartesianPoint = .zero
        
        if point.x < origin.x {
            cartesianPoint.x = -(origin.x - point.x)
        } else if point.x > origin.x {
            cartesianPoint.x = point.x - origin.x
        }
        
        if point.y > origin.y {
            cartesianPoint.y = -(point.y - origin.y)
        } else if point.y < origin.y {
            cartesianPoint.y = origin.y - point.y
        }
        
        return cartesianPoint
    }
}
