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
@available(*, deprecated, renamed: "CartesianPoint")
public typealias GraphPoint = CGPoint

@available(*, deprecated, renamed: "CartesianPoint")
public extension GraphPoint {
    /// The minimum radius of a circle that would contain this `GraphPoint`
    @available(*, deprecated, renamed: "CartesianPoint.minimumAxis")
    var minimumRadius: CGFloat {
        return max(x, y)
    }
    
    /// Uses the mathematical 'Law of Sines' to determine a `GraphPoint` for the supplied degree and radius
    ///
    /// - note: Degree 0 (zero) is the positive X axis and increments clockwise.
    @available(*, deprecated, renamed: "CartesianPoint.make(for:radius:clockwise:)")
    static func graphPoint(degree: CGFloat, radius: CGFloat) -> GraphPoint {
        do {
            return try CartesianPoint.make(for: Radius(radius), degree: Degree(degree)).cgPoint
        } catch {
            return .zero
        }
    }
    
    /// Uses the Pythagorean Theorem to solve for the x or y intercept given the
    /// supplied `GraphPoint` `sideA`.
    ///
    /// - note Degree 0 (zero) is the positive x axis and increments clockwise.
    @available(*, deprecated, renamed: "CartesianPoint.make(for:degree:modifiedBy:clockwise:)")
    static func graphPoint(degree: CGFloat, radius: CGFloat, boundedBy sideA: GraphPoint) -> GraphPoint {
        let modifier = CartesianPoint(x: Float(sideA.x), y: Float(sideA.y))
        do {
            let point = try CartesianPoint.make(for: Radius(radius), degree: Degree(degree), modifier: modifier)
            return GraphPoint(x: CGFloat(point.x), y: CGFloat(point.y))
        } catch {
            return .zero
        }
    }
    
    /// Uses the mathematical 'Law of Cotangents' to determine the degree for a `GraphPoint`
    ///
    /// - note: Degree 0 (zero) is the positive X axis and increments clockwise.
    @available(*, deprecated, renamed: "Degree.make(for:clockwise:)")
    static func degree(graphPoint: GraphPoint) -> CGFloat {
        do {
            return CGFloat(try Degree.make(for: graphPoint.point))
        } catch {
            return .zero
        }
    }
}

#endif
