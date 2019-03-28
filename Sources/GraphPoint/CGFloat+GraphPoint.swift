#if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS))

import CoreGraphics

public extension CGFloat {
    /// Converts an angular degree to radians
    var radians: CGFloat {
        return CGFloat(Double(self) * (Double.pi / 180))
    }
    
    /// Converts a radian value to angular degree
    var degrees: CGFloat {
        return CGFloat(Double(self) * (180 / Double.pi))
    }
}

#endif
