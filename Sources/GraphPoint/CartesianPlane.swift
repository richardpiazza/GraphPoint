import Foundation
import Swift2D

/// A Cartesian plane is defined by two perpendicular number lines: the x-axis, which is horizontal, and the y-axis,
/// which is vertical. Using these axes, we can describe any point in the plane using an ordered pair of numbers.
///
/// In **GraphPoint** ever rectangle is a cartesian plane with the origin _typically_ at the center.
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
    /// The point that represents the {0, 0} origin of the plane.
    var cartesianOrigin: CartesianOrigin {
        return center
    }
    
    /// The length of the shortest axis found in this plane.
    var minimumAxis: Float {
        return min(midX, midY)
    }
    
    /// The length of the shortest axis found in this plane.
    var maximumAxis: Float {
        return max(midX, midY)
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
    /// - parameter point: A standard `Point` (which uses top-left as {0, 0}).
    /// - returns A `CartesianPoint` which has been translated onto the _plane_.
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
