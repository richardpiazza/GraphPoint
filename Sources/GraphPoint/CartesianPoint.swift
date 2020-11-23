import Foundation
import Swift2D

/// A point within a `CartesianPlane`
///
/// The x & y coordinates of a `CartesianPoint` represent the offset from the planes 'origin' {0, 0}.
///
/// ## Example
///
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
    
    /// The `Quadrant` that contains the point.
    ///
    /// Special conditions are used when a point rests on an axis:
    /// * {0, 0}: .I
    /// * {>=0, 0}: .I
    /// * {0, >=0}: .II
    /// * {<0, 0}: .III
    /// * {0, <0}: .IV
    var quadrant: Quadrant {
        if x == 0.0 {
            if y == 0.0 {
                return .I
            } else if y >= 0.0 {
                return .II
            } else {
                return .IV
            }
        } else if x > 0.0 {
            if y == 0.0 {
                return .I
            } else if y > 0.0 {
                return .I
            } else {
                return .IV
            }
        } else {
            if y == 0.0 {
                return .III
            } else if y > 0.0 {
                return .II
            } else {
                return .III
            }
        }
    }
}

public extension CartesianPoint {
    /// Calculates the `CartesianPoint` for a given degree and radius from the _origin_.
    ///
    /// Uses the mathematical **Law of Sines**.
    ///
    /// - parameter radius: The straight line distance from the _origin_.
    /// - parameter degree: The angular degree (0-360), clockwise from the x-axis.
    /// - returns:A `CartesianPoint` with offsets from the _origin_.
    static func make(for radius: Radius, degree: Degree, clockwise: Bool = true) throws -> CartesianPoint {
        guard degree >= 0.0, degree <= 360.0 else {
            throw GraphPointError.invalidDegree(degree)
        }
        
        guard radius >= 0.0 else {
            throw GraphPointError.invalidRadius(radius)
        }
        
        guard radius > 0.0 else {
            return .zero
        }
        
        let rightAngle: Float = 90.0
        let sinRight = sin(rightAngle.radians)
        var rise: Float = 0.0
        var run: Float = 0.0
        var point: CartesianPoint = .zero
        
        switch clockwise {
        case true:
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
        case false:
            // TODO: Handled anti-clockwise
            break
        }
        
        return point
    }
    
    /// Calculates the `CartesianPoint` for a given degree and radius from the _origin_ limited by another point.
    ///
    /// Uses the **Pythagorean Theorem** to solve for the intercept:
    /// * **c**: calculated based on `degree` and `radius`.
    /// * **a**: supplied via the `point` (x/y based on closest axis)
    ///
    /// - parameter radius: The straight line distance from the _origin_.
    /// - parameter degree: The angular degree (0-360), clockwise from the x-axis.
    /// - parameter modifier: The point used to clip or expand the result. The nearest axis value is used.
    static func make(for radius: Radius, degree: Degree, modifier: CartesianPoint, clockwise: Bool = true) throws -> CartesianPoint {
        guard degree >= 0.0, degree <= 360.0 else {
            throw GraphPointError.invalidDegree(degree)
        }
        
        guard radius >= 0.0 else {
            throw GraphPointError.invalidRadius(radius)
        }
        
        guard radius > 0.0 else {
            return .zero
        }
        
        var point = CartesianPoint()
        
        switch clockwise {
        case true:
            if (degree >= 315) {
                point.x = sqrtf(powf(radius, 2) - powf(modifier.y, 2))
                point.y = modifier.y
            } else if (degree >= 270) {
                point.x = modifier.x
                point.y = sqrtf(powf(radius, 2) - powf(modifier.x, 2))
            } else if (degree >= 225) {
                point.x = modifier.x
                point.y = sqrtf(powf(radius, 2) - powf(modifier.x, 2))
            } else if (degree >= 180) {
                point.x = -(sqrtf(powf(radius, 2) - powf(modifier.y, 2)))
                point.y = modifier.y
            } else if (degree >= 135) {
                point.x = -(sqrtf(powf(radius, 2) - powf(modifier.y, 2)))
                point.y = modifier.y
            } else if (degree >= 90) {
                point.x = modifier.x
                point.y = -(sqrtf(powf(radius, 2) - powf(modifier.x, 2)))
            } else if (degree >= 45) {
                point.x = modifier.x
                point.y = -(sqrtf(powf(radius, 2) - powf(modifier.x, 2)))
            } else if (degree >= 0) {
                point.x = sqrtf(powf(radius, 2) - powf(modifier.y, 2))
                point.y = modifier.y
            }
        case false:
            //TODO: Determine if calculations should be modified.
            break
        }
        
        return point
    }
}
