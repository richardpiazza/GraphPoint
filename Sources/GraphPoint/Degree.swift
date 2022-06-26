import Foundation
import Swift2D

/// A degree is a measurement of a plane angle, defined so that a full rotation is 360 degrees.
///
/// Degree 0 (zero) is the positive x axis and increments clockwise.
/// TODO: Rotating clockwise to match CoreGraphics, but should this match the Quadrant flow?
public typealias Degree = Double

public extension Degree {
    /// Converts an angular degree to radians
    var radians: Radian {
        return self * (.pi / 180.0)
    }
    
    /// Calculates the angular degree for a given point.
    ///
    /// Uses the mathematical **Law of Cotangents**.
    ///
    /// - parameters:
    ///   - point: A `CartesianPoint` with offsets from the _origin_.
    /// - returns:The angular degree (0-360), clockwise from the x-axis.
    static func make(for cartesianPoint: CartesianPoint, clockwise: Bool = true) throws -> Degree {
        guard cartesianPoint != .nan else {
            throw GraphPointError.invalidPoint(cartesianPoint)
        }
        
        guard cartesianPoint != .zero else {
            throw GraphPointError.invalidPoint(cartesianPoint)
        }
        
        let degree: Degree
        let quadrant = Quadrant(cartesianPoint: cartesianPoint)
        
        switch quadrant {
        case .I:
            let midPoint = try CartesianPoint.make(for: cartesianPoint.minimumAxis, degree: 315.0)
            if cartesianPoint.x <= midPoint.x {
                degree = 270.0 + atan(cartesianPoint.x / cartesianPoint.y).degrees
            } else {
                degree = 360.0 - atan(cartesianPoint.y / cartesianPoint.x).degrees
            }
        case .II:
            let midPoint = try CartesianPoint.make(for: cartesianPoint.minimumAxis, degree: 225.0)
            if cartesianPoint.x <= midPoint.x {
                degree = 180.0 + atan(cartesianPoint.y / abs(cartesianPoint.x)).degrees
            } else {
                degree = 270.0 - atan(abs(cartesianPoint.x) / cartesianPoint.y).degrees
            }
        case .III:
            let midPoint = try CartesianPoint.make(for: cartesianPoint.minimumAxis, degree: 135.0)
            if cartesianPoint.x <= midPoint.x {
                degree = 180.0 - atan(abs(cartesianPoint.y) / abs(cartesianPoint.x)).degrees
            } else {
                degree = 90.0 + atan(abs(cartesianPoint.x) / abs(cartesianPoint.y)).degrees
            }
        case .IV:
            let midPoint = try CartesianPoint.make(for: cartesianPoint.minimumAxis, degree: 45.0)
            if cartesianPoint.x <= midPoint.x {
                degree = atan(abs(cartesianPoint.y) / cartesianPoint.x).degrees
            } else {
                degree = 90.0 - atan(cartesianPoint.x / abs(cartesianPoint.y)).degrees
            }
        }
        
        if !clockwise {
            return 360.0 - degree
        }
        
        return degree
    }
}
