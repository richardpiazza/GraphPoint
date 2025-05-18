import Foundation

/// The radian is the SI unit for measuring angles
public typealias Radian = Double

public extension Radian {
    /// Converts a radian value to angular degree
    var degrees: Degree {
        self * (180.0 / .pi)
    }
}
