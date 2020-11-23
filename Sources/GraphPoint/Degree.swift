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
}
