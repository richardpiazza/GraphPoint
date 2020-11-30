import Foundation

/// The radian is the SI unit for measuring angles
public typealias Radian = Float

public extension Float {
    /// Converts a radian value to angular degree
    var degrees: Degree {
        return self * (180.0 / .pi)
    }
}
