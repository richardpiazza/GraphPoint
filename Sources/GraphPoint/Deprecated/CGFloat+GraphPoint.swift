#if canImport(CoreGraphics)
import CoreGraphics

public extension CGFloat {
    /// Converts an angular degree to radians
    @available(*, deprecated, renamed: "Degree.radians")
    var radians: CGFloat {
        return self * (.pi / CGFloat(180))
    }
    
    /// Converts a radian value to angular degree
    @available(*, deprecated, renamed: "Radian.degrees")
    var degrees: CGFloat {
        return self * (CGFloat(180) / .pi)
    }
}

#endif
