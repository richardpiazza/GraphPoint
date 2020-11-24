import Foundation

/// A sub-region of the `CartesianPlane`.
///
/// The axes of a two-dimensional Cartesian system divide the plane into four infinite regions, called quadrants, each
/// bounded by two half-axes. When the axes are drawn according to the mathematical custom, the numbering goes
/// counter-clockwise starting from the upper right ("northeast") quadrant.
public enum Quadrant: Int, CaseIterable {
    /// Quadrant 1
    /// * x: + (positive)
    /// * y: + (positive)
    case I = 1
    /// Quadrant 2
    /// * x: - (negative)
    /// * y: + (positive)
    case II = 2
    /// Quadrant 3
    /// * x: - (negative)
    /// * y: - (negative)
    case III = 3
    /// Quadrant 4
    /// * x: + (positive)
    /// * y: - (negative)
    case IV = 4
}

public extension Quadrant {
    /// Determines a `Quadrant` based on an angular degree and rotational direction.
    ///
    /// - note: The 'clockwise' parameter here defaults to **true** to match the implementations throughout the rest of
    ///         the library. But, `Quadrant`s are inherently counter-clockwise.
    init(degree: Degree, clockwise: Bool = true) throws {
        guard degree >= 0.0, degree <= 360.0 else {
            throw GraphPointError.invalidDegree(degree)
        }
        
        switch clockwise {
        case true:
            if degree >= 0.0 && degree <= 90.0 {
                self = .IV
            } else if degree >= 90.0 && degree <= 180.0 {
                self = .III
            } else if degree >= 180.0 && degree <= 270.0 {
                self = .II
            } else {
                self = .I
            }
        case false:
            if degree >= 0.0 && degree <= 90.0 {
                self = .I
            } else if degree >= 90.0 && degree <= 180.0 {
                self = .II
            } else if degree >= 180.0 && degree <= 270.0 {
                self = .III
            } else {
                self = .IV
            }
        }
    }
    
    /// Initializes a `Quadrant` that contains the point.
    ///
    /// Special conditions are used when a point rests on an axis:
    /// * {0, 0}: .I
    /// * {>=0, 0}: .I
    /// * {0, >=0}: .II
    /// * {<0, 0}: .III
    /// * {0, <0}: .IV
    init(cartesianPoint: CartesianPoint) {
        if cartesianPoint.x == 0.0 {
            if cartesianPoint.y == 0.0 {
                self = .I
            } else if cartesianPoint.y >= 0.0 {
                self = .II
            } else {
                self = .IV
            }
        } else if cartesianPoint.x > 0.0 {
            if cartesianPoint.y == 0.0 {
                self = .I
            } else if cartesianPoint.y > 0.0 {
                self = .I
            } else {
                self = .IV
            }
        } else {
            if cartesianPoint.y == 0.0 {
                self = .III
            } else if cartesianPoint.y > 0.0 {
                self = .II
            } else {
                self = .III
            }
        }
    }
}
