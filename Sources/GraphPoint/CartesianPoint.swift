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

public extension CartesianPoint {
    /// The minimum axis for a `CartesianPlane` that would contain this point.
    var minimumAxis: Float {
        return max(abs(x), abs(y))
    }
    
    var quadrant: CartesianPlane.Quadrant {
        if x >= 0.0 {
            if y >= 0.0 {
                return .I
            } else {
                return .IV
            }
        } else {
            if y >= 0.0 {
                return .II
            } else {
                return .III
            }
        }
    }
}

public extension CartesianPoint {
    enum Error: Swift.Error {
        case invalidDegree
        case invalidRadius
        case invalidPoint
    }
    
    /// Calculates the `CartesianPoint` for a given degree and radius from the _origin_.
    ///
    /// Uses the mathematical **Law of Sines**.
    ///
    /// - parameter degree: The angular degree (0-360), clockwise from the x-axis.
    /// - parameter radius: The straight line distance from the _origin_.
    /// - returns:A `CartesianPoint` with offsets from the _origin_.
    static func point(for degree: Degree, radius: Radius) throws -> CartesianPoint {
        guard degree >= 0.0, degree <= 360.0 else {
            throw Error.invalidDegree
        }
        
        guard radius >= 0.0 else {
            throw Error.invalidRadius
        }
        
        guard radius > 0.0 else {
            return .zero
        }
        
        let rightAngle: Float = 90.0
        let sinRight = sin(rightAngle.radians)
        var rise: Float = 0.0
        var run: Float = 0.0
        var point: CartesianPoint = .zero
        
        if degree > 315 {
            rise = 360.0 - degree
            run = 180.0 - rightAngle - rise
            point.x = (radius / sinRight) * sin(run.radians)
            point.y = (radius / sinRight) * sin(rise.radians)
        } else if degree > 270 {
            run = degree - 270.0
            rise = 180.0 - rightAngle - run
            point.x = (radius / sinRight) * sin(run.radians)
            point.y = (radius / sinRight) * sin(rise.radians)
        } else if degree > 225 {
            run = 270.0 - degree
            rise = 180.0 - rightAngle - run
            point.x = -1.0 * (radius / sinRight) * sin(run.radians)
            point.y = (radius / sinRight) * sin(rise.radians)
        } else if degree > 180 {
            rise = degree - 180.0
            run = 180.0 - rightAngle - rise
            point.x = -1.0 * (radius / sinRight) * sin(run.radians)
            point.y = (radius / sinRight) * sin(rise.radians)
        } else if degree > 135 {
            rise = 180.0 - degree
            run = 180.0 - rightAngle - rise
            point.x = -1.0 * (radius / sinRight) * sin(run.radians)
            point.y = -1.0 * (radius / sinRight) * sin(rise.radians)
        } else if degree > 90 {
            run = degree - 90.0
            rise = 180.0 - rightAngle - run
            point.x = -1.0 * (radius / sinRight) * sin(run.radians)
            point.y = -1.0 * (radius / sinRight) * sin(rise.radians)
        } else if degree > 45 {
            run = 90.0 - degree
            rise = 180.0 - rightAngle - run
            point.x = (radius / sinRight) * sin(run.radians)
            point.y = -1.0 * (radius / sinRight) * sin(rise.radians)
        } else if degree >= 0 {
            rise = degree
            run = 180.0 - rightAngle - rise
            point.x = (radius / sinRight) * sin(run.radians)
            point.y = -1.0 * (radius / sinRight) * sin(rise.radians)
        }
        
        return point
    }
    
    /// Calculates the angular degree for a given point.
    ///
    /// Uses the mathematical **Law of Cotangents**.
    ///
    /// - parameter point: A `CartesianPoint` with offsets from the _origin_.
    /// - returns:The angular degree (0-360), clockwise from the x-axis.
    static func degree(for point: CartesianPoint) throws -> Degree {
        guard point != .nan else {
            throw Error.invalidPoint
        }
        
        guard point != .zero else {
            throw Error.invalidPoint
        }
        
        switch point.quadrant {
        case .I:
            let midPoint = try Self.point(for: 315.0, radius: point.minimumAxis)
            if point.x <= midPoint.x {
                return 270.0 + atan(point.x / point.y).degrees
            } else {
                return 360.0 - atan(point.y / point.x).degrees
            }
        case .II:
            let midPoint = try Self.point(for: 225.0, radius: point.minimumAxis)
            if point.x <= midPoint.x {
                return 180.0 + atan(point.y / abs(point.x)).degrees
            } else {
                return 270.0 - atan(abs(point.x) / point.y).degrees
            }
        case .III:
            let midPoint = try Self.point(for: 135.0, radius: point.minimumAxis)
            if point.x <= midPoint.x {
                return 180.0 - atan(abs(point.y) / abs(point.x)).degrees
            } else {
                return 90.0 + atan(abs(point.x) / abs(point.y)).degrees
            }
        case .IV:
            let midPoint = try Self.point(for: 45.0, radius: point.minimumAxis)
            if point.x <= midPoint.x {
                return atan(abs(point.y) / point.x).degrees
            } else {
                return 90.0 - atan(point.x / abs(point.y)).degrees
            }
        }
    }
}
