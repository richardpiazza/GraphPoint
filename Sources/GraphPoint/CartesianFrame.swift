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
    /// - parameter point1: The first `CartesianPoint` of the chord.
    /// - parameter point2: The second `CartesianPoint` of the chord.
    /// - parameter radius: The radius of the circle on which the chord is present.
    /// - returns: A `CartesianFrame` containing all of the points.
    /// - throws: GraphPointError.unhandledQuadrantTransition(_:_:)
    static func make(for point1: CartesianPoint, point2: CartesianPoint, radius: Radius) throws -> CartesianFrame {
        var frame = make(for: [point1, point2])
        
        let startQuadrant = Quadrant(cartesianPoint: point1)
        let endQuadrant = Quadrant(cartesianPoint: point2)
        
        guard startQuadrant != endQuadrant else {
            return frame
        }
        
        switch (startQuadrant, endQuadrant) {
        case (.I, .IV), (.IV, .I):
            let maxAxis = frame.origin.x + frame.width
            if maxAxis < radius {
                frame.size.width += (radius - maxAxis)
            }
        case (.II, .I), (.I, .II):
            let maxAxis = frame.origin.y
            if maxAxis < radius {
                frame.origin.y += (radius - maxAxis)
                frame.size.height += (radius - maxAxis)
            }
        case (.III, .II), (.II, .III):
            let maxAxis = abs(frame.origin.x)
            if maxAxis < radius {
                frame.origin.x -= (radius - maxAxis)
                frame.size.width += (radius - maxAxis)
            }
        case (.IV, .III), (.III, .IV):
            let maxAxis = abs(frame.origin.y) + frame.size.height
            if maxAxis < radius {
                frame.size.height += (radius - maxAxis)
            }
        default:
            throw GraphPointError.unhandledQuadrantTransition(startQuadrant, endQuadrant)
        }
        
        return frame
    }
}
