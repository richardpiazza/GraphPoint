import Foundation

/// A degree is a measurement of a plane angle, defined so that a full rotation is 360 degrees.
///
/// Degree 0 (zero) is the positive x axis and increments clockwise.
/// TODO: Rotating clockwise to match CoreGraphics, but should this match the Quadrant flow?
public typealias Degree = Float

public extension Degree {
    /// Converts an angular degree to radians
    var radians: Radian {
        return self * (.pi / 180.0)
    }
    
    /// Calculates the angular degree for a given point.
    ///
    /// Uses the mathematical **Law of Cotangents**.
    ///
    /// - parameter point: A `CartesianPoint` with offsets from the _origin_.
    /// - returns:The angular degree (0-360), clockwise from the x-axis.
    static func make(for point: CartesianPoint, clockwise: Bool = true) throws -> Degree {
        guard point != .nan else {
            throw GraphPointError.invalidPoint(point)
        }
        
        guard point != .zero else {
            throw GraphPointError.invalidPoint(point)
        }
        
        let degree: Degree
        let quadrant = Quadrant(cartesianPoint: point)
        
        switch quadrant {
        case .I:
            let midPoint = try CartesianPoint.make(for: point.minimumAxis, degree: 315.0)
            if point.x <= midPoint.x {
                degree = 270.0 + atan(point.x / point.y).degrees
            } else {
                degree = 360.0 - atan(point.y / point.x).degrees
            }
        case .II:
            let midPoint = try CartesianPoint.make(for: point.minimumAxis, degree: 225.0)
            if point.x <= midPoint.x {
                degree = 180.0 + atan(point.y / abs(point.x)).degrees
            } else {
                degree = 270.0 - atan(abs(point.x) / point.y).degrees
            }
        case .III:
            let midPoint = try CartesianPoint.make(for: point.minimumAxis, degree: 135.0)
            if point.x <= midPoint.x {
                degree = 180.0 - atan(abs(point.y) / abs(point.x)).degrees
            } else {
                degree = 90.0 + atan(abs(point.x) / abs(point.y)).degrees
            }
        case .IV:
            let midPoint = try CartesianPoint.make(for: point.minimumAxis, degree: 45.0)
            if point.x <= midPoint.x {
                degree = atan(abs(point.y) / point.x).degrees
            } else {
                degree = 90.0 - atan(point.x / abs(point.y)).degrees
            }
        }
        
        if !clockwise {
            return 360.0 - degree
        }
        
        return degree
    }
}
