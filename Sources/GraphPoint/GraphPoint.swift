#if canImport(CoreGraphics)
import CoreGraphics

/// A point within a CGRect having cartesian coordinates as an offset of
/// the `GraphOrigin`
///
/// For example:
///
/// * Given: **CGRect(0, 0, 100, 100)**
/// *   the: **CGPoint(75, 25)**
/// *   has: **GraphPoint(25, 25)**
public typealias GraphPoint = CGPoint

public extension GraphPoint {
    /// The minimum radius of a circle that would contain this `GraphPoint`
    var minimumRadius: CGFloat {
        return max(x, y)
    }
    
    /// Uses the mathematical 'Law of Sines' to determine a `GraphPoint` for the supplied degree and radius
    ///
    /// - note: Degree 0 (zero) is the positive X axis and increments clockwise.
    static func graphPoint(degree: CGFloat, radius: CGFloat) -> GraphPoint {
        do {
            let cartesianPoint = try CartesianPoint.point(for: Degree(degree), radius: Radius(radius)).cgPoint
            return cartesianPoint
        } catch {
            return .zero
        }
    }
    
    /// Uses the Pythagorean Theorem to solve for the x or y intercept given the
    /// supplied `GraphPoint` `sideA`.
    ///
    /// - note Degree 0 (zero) is the positive x axis and increments clockwise.
    static func graphPoint(degree: CGFloat, radius: CGFloat, boundedBy sideA: GraphPoint) -> GraphPoint {
        var point = CGPoint.zero
        
        guard degree >= 0.0 && degree <= 360.0 else {
            return point
        }
        
        guard radius > 0.0 else {
            return point
        }
        
        if (degree >= 315) {
            point.x = CGFloat(sqrtf(powf(Float(radius), 2) - powf(Float(sideA.y), 2)))
            point.y = sideA.y
        } else if (degree >= 270) {
            point.x = sideA.x
            point.y = CGFloat(sqrtf(powf(Float(radius), 2) - powf(Float(sideA.x), 2)))
        } else if (degree >= 225) {
            point.x = sideA.x
            point.y = CGFloat(sqrtf(powf(Float(radius), 2) - powf(Float(sideA.x), 2)))
        } else if (degree >= 180) {
            point.x = -CGFloat(sqrtf(powf(Float(radius), 2) - powf(Float(sideA.y), 2)))
            point.y = sideA.y
        } else if (degree >= 135) {
            point.x = -CGFloat(sqrtf(powf(Float(radius), 2) - powf(Float(sideA.y), 2)))
            point.y = sideA.y
        } else if (degree >= 90) {
            point.x = sideA.x
            point.y = -CGFloat(sqrtf(powf(Float(radius), 2) - powf(Float(sideA.x), 2)))
        } else if (degree >= 45) {
            point.x = sideA.x
            point.y = -CGFloat(sqrtf(powf(Float(radius), 2) - powf(Float(sideA.x), 2)))
        } else if (degree >= 0) {
            point.x = CGFloat(sqrtf(powf(Float(radius), 2) - powf(Float(sideA.y), 2)))
            point.y = sideA.y
        }
        
        return point
    }
    
    /// Uses the mathematical 'Law of Cotangents' to determine the degree for a `GraphPoint`
    ///
    /// - note: Degree 0 (zero) is the positive X axis and increments clockwise.
    static func degree(graphPoint: GraphPoint) -> CGFloat {
        do {
            return CGFloat(try CartesianPoint.degree(for: graphPoint.point))
        } catch {
            return 0.0
        }
    }
}

#endif
