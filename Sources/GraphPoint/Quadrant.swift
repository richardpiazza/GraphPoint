import Foundation

/// A sub-region of the `CartesianPlane`.
///
/// The axes of a two-dimensional Cartesian system divide the plane into four infinite regions, called quadrants, each
/// bounded by two half-axes. When the axes are drawn according to the mathematical custom, the numbering goes
/// counter-clockwise starting from the upper right ("northeast") quadrant.
public enum Quadrant: Int, CaseIterable {
    /// North-East / Top-Right
    case I = 1
    /// North-West / Top-Left
    case II = 2
    /// South-West / Bottom-Left
    case III = 3
    /// South-East / Bottom-Right
    case IV = 4
    
    
    public var clockwiseStartDegree: Degree {
        switch self {
        case .I: return 270.0
        case .II: return 180.0
        case .III: return 90.0
        case .IV: return 0.0
        }
    }
    
    public var clockwiseEndDegree: Degree {
        switch self {
        case .I: return 360.0
        case .II: return 270.0
        case .III: return 180.0
        case .IV: return 90.0
        }
    }
    
    public var counterClockwiseStartDegree: Degree {
        switch self {
        case .I: return 0.0
        case .II: return 90.0
        case .III: return 180.0
        case .IV: return 270.0
        }
    }
    
    public var counterClockwiseEndDegree: Degree {
        switch self {
        case .I: return 90.0
        case .II: return 180.0
        case .III: return 270.0
        case .IV: return 360.0
        }
    }
    
    
    public init(degree: Degree, clockwise: Bool = true) {
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
    
    public init(cartesianPoint: CartesianPoint) {
        if cartesianPoint.x >= 0 {
            if cartesianPoint.y >= 0 {
                self = .I
            } else {
                self = .IV
            }
        } else {
            if cartesianPoint.y >= 0 {
                self = .II
            } else {
                self = .III
            }
        }
    }
}
