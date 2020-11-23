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
        
        return CartesianFrame(origin: minXMaxY, size: Size(width: abs(maxXMinY.x - minXMaxY.x), height: abs(maxXMinY.y - minXMaxY.y)))
    }
    
    /// Identifies the minimum `CartesianFrame` that contains all of the provided points, accounting for any expansion
    /// needed when crossing an axis (start/end) at a given distance (radius) from the origin.
    ///
    /// - parameter points: The `CartesianPoint`s with which to map into a frame.
    /// - parameter radius:
    /// - parameter startDegree:
    /// - parameter endDegree:
    /// - parameter clockwise:
    /// - returns: A `CartesianFrame` containing all of the points.
    static func make(for points: [CartesianPoint], radius: Radius, startDegree: Degree, endDegree: Degree, clockwise: Bool = true) -> CartesianFrame {
        var frame = make(for: points)
        
        let startQuadrant = Quadrant(degree: startDegree, clockwise: clockwise)
        let endQuadrant = Quadrant(degree: endDegree, clockwise: clockwise)
        
        switch clockwise {
        case true:
            switch (startQuadrant, endQuadrant) {
            case (.I, .IV):
                let maxAxis = frame.origin.x + frame.width
                if maxAxis < radius {
                    frame.size.width += (radius - maxAxis)
                }
            case (.II, .I):
                let maxAxis = frame.origin.y
                if maxAxis < radius {
                    frame.origin.y += (radius - maxAxis)
                    frame.size.height += (radius - maxAxis)
                }
            case (.III, .II):
                let maxAxis = abs(frame.origin.x)
                if maxAxis < radius {
                    frame.origin.x -= (radius - maxAxis)
                    frame.size.width += (radius - maxAxis)
                }
            case (.IV, .III):
                let maxAxis = abs(frame.origin.y) + frame.size.height
                if maxAxis < radius {
                    frame.size.height += (radius - maxAxis)
                }
            default:
                //TODO: Unhandled Multi-Quadrant Crossing.
                break
            }
        case false:
            //TODO: Handle anti-clockwise calculations
            break
        }
        
        return frame
    }
}
