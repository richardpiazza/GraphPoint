import Foundation
import Swift2D

/// A `Rect` contained within a `CartesianPlane` with an `origin` relative to the `cartesianOrigin` of the plane.
///
/// ## Example
///
/// ```swift
/// let plane = CartesianPlan(size: Size(width: 100, height: 100))
/// let rect = Rect(origin: Point(x: 40, y: 40), size: Size(width: 10, height: 10))
/// let frame = Rect(origin: Point(x: -10, y: 10), size: Size(width: 10, height: 10))
/// ```
public typealias CartesianFrame = Rect

public extension CartesianFrame {
    typealias Offset = Point
    
    /// The _x_ & _y_ offset required to reach the cartesian origin of the plane that contains this frame.
    ///
    /// The size of the plane is irrelevant. The assumption being made is that the plane is equal to or larger than the
    /// size of the frame.
    ///
    /// TODO: Verify this behavior, as it seems like this should be a strict inversion of the frame origin.
    ///
    /// ```
    /// ┌────────────────────────▲───────────────────────┐
    /// │                        │                       │
    /// │                        │                       │
    /// │            P───────────┼───────────┐           │
    /// │            │           │           │           │
    /// │            │  (x, y)   │           │           │
    /// │            │           │           │           │
    /// ◀────────────┼───────────O───────────┼───────────▶
    /// │            │           │           │           │
    /// │            │           │           │           │
    /// │            │           │     Frame │           │
    /// │            └───────────┼───────────┘           │
    /// │                        │                       │
    /// │                        │                 Plane │
    /// └────────────────────────▼───────────────────────┘
    /// ```
    var offsetToCartesianOrigin: Offset {
        return (x <= 0) ? Offset(x: abs(x), y: y) : Offset(x: -(x), y: y)
    }
    
    /// Calculates the _point_ if the origin were modified by the point.
    ///
    /// TODO: Clarify & Define
    func originModifiedBy(_ cartesianPoint: CartesianPoint) -> CartesianPoint {
        return CartesianPoint(
            x: abs(origin.x - cartesianPoint.x),
            y: abs(origin.y - cartesianPoint.y)
        )
    }
}

public extension CartesianFrame {
    /// Identifies the minimum `CartesianFrame` that contains all of the provided points.
    ///
    /// - parameter points: The `CartesianPoint`s with which to map into a frame.
    /// - returns: A `CartesianFrame` containing all of the points.
    static func make(for points: [CartesianPoint]) -> CartesianFrame {
        var minXMaxY = Point()
        var maxXMinY = Point()
        
        // TODO: Check the logic here. Is checking == 0 needed, or could it provide false results?
        
        points.forEach { (point) in
            if point.x < minXMaxY.x || minXMaxY.x == 0 {
                minXMaxY.x = point.x
            }
            
            if point.y > minXMaxY.y || minXMaxY.y == 0 {
                minXMaxY.y = point.y
            }
            
            if point.x > maxXMinY.x || maxXMinY.x == 0 {
                maxXMinY.x = point.x
            }
            
            if point.y < maxXMinY.y || maxXMinY.y == 0 {
                maxXMinY.y = point.y
            }
        }
        
        return CartesianFrame(
            origin: minXMaxY,
            size: Size(
                width: abs(maxXMinY.x - minXMaxY.x),
                height: abs(maxXMinY.y - minXMaxY.y)
            )
        )
    }
    
    /// Identifies the minimum `CartesianFrame` that contains the provided points, accounting for any expansion needed
    /// when crossing an axis at a given distance (radius) from the origin.
    ///
    /// This is especially useful when determining the frame needed for a specific **chord** of a circle.
    ///
    /// ## Example
    ///
    /// Given the points (A, B) and the radius (R), a cartesian frame can be determined that encompasses all of the
    /// points.
    ///
    /// ```
    ///               ▲
    ///               │
    ///               │
    ///           .───┼───.
    ///         ,'    │    ┌─────┐
    ///       ,'      │    │ A   │
    ///      ;        │    │   : │
    ///      │        │    │   │ │
    /// ◀────┼────────┼────┼───R─┼───▶
    ///      :        │    │   ; │
    ///       ╲       │    │  ╱  │
    ///        `.     │    │,B   │
    ///          `.   │   ,└─────┘
    ///            `──┼──'
    ///               │
    ///               │
    ///               ▼
    /// ```
    ///
    /// - parameter arc: The points and radius of the circle on which the chord is present.
    /// - parameter points: Additional points that extend the resulting frame.
    /// - returns: A `CartesianFrame` containing all of the points.
    /// - throws: GraphPointError.unhandledQuadrantTransition(_:_:)
    static func make(for arc: Arc, points: [CartesianPoint]) throws -> CartesianFrame {
        let startQuadrant = try Quadrant(degree: arc.startingDegree, clockwise: arc.clockwise)
        let endQuadrant = try Quadrant(degree: arc.endingDegree, clockwise: arc.clockwise)
        var frame = make(for: points)
        
        guard startQuadrant != endQuadrant else {
            return frame
        }
        
        switch (startQuadrant, endQuadrant) {
        case (.I, .IV), (.IV, .I):
            let maxAxis = frame.origin.x + frame.width
            if maxAxis < arc.radius {
                frame.size.width += (arc.radius - maxAxis)
            }
        case (.II, .I), (.I, .II):
            let maxAxis = frame.origin.y
            if maxAxis < arc.radius {
                frame.origin.y += (arc.radius - maxAxis)
                frame.size.height += (arc.radius - maxAxis)
            }
        case (.III, .II), (.II, .III):
            let maxAxis = abs(frame.origin.x)
            if maxAxis < arc.radius {
                frame.origin.x -= (arc.radius - maxAxis)
                frame.size.width += (arc.radius - maxAxis)
            }
        case (.IV, .III), (.III, .IV):
            let maxAxis = abs(frame.origin.y) + frame.size.height
            if maxAxis < arc.radius {
                frame.size.height += (arc.radius - maxAxis)
            }
        default:
            throw GraphPointError.unhandledQuadrantTransition(startQuadrant, endQuadrant)
        }
        
        return frame
    }
}
