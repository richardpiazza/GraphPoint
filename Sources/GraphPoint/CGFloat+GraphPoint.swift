#if canImport(CoreGraphics)
import CoreGraphics

@available(*, deprecated)
public extension CGFloat {
    /// Converts an angular degree to radians
    var radians: CGFloat {
        return self * (.pi / CGFloat(180))
    }
    
    /// Converts a radian value to angular degree
    var degrees: CGFloat {
        return self * (CGFloat(180) / .pi)
    }
}

#endif
