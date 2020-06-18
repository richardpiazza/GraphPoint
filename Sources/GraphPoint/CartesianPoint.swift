import Foundation
import Swift2D

/// A point within a `CartesianPlane`
///
/// The x & y coordinates of a `CartesianPoint` represent the offset from the planes 'origin' {0, 0}. For example:
/// ```swift
/// let plane = CartesianPlane(size: Size(width: 100, height: 100))
/// // plane.cartesianOrigin == Point(x: 50, y: 50)
/// let point1 = Point(x: 75, y: 25)
/// let cartesianPoint1 = CartesianPoint(x: 25, y: 25)
/// // point1 == cartesianPoint1
/// let point2 = Point(x: 25, y: 75)
/// let cartesianPoint2 = CartesianPoint(x: -25, y: -25)
/// // point2 == cartesianPoint2
/// ```
public typealias CartesianPoint = Point
