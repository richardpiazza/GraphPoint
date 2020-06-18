import Foundation
import Swift2D

/// A cartesian-based struct that describes the relationship of any particular `Point`
/// to the _center_ of a cartesian graph.
public struct VectorPoint {
    public enum Sign: String {
        case plus = "+"
        case minus = "-"
    }
    
    public typealias Offset = (sign: Sign, multiplier: Float)
    
    public var x: Offset
    public var y: Offset
    
    public init(x: Offset, y: Offset) {
        self.x = x
        self.y = y
    }
    
    /// Initializes a `VectorPoint` for a given `Point` container in the provided `Rect`.
    public init(point: Point, in rect: Rect) {
        let radius = rect.size.maxRadius
        let cartesianPoint = rect.cartesianPoint(for: point)
        
        if cartesianPoint.x < 0 {
            x = (.minus, abs(cartesianPoint.x) / radius)
        } else {
            x = (.plus, cartesianPoint.x / radius)
        }
        
        if cartesianPoint.y < 0 {
            y = (.plus, abs(cartesianPoint.y) / radius)
        } else {
            y = (.minus, cartesianPoint.y / radius)
        }
    }
}

// MARK: - CustomStringConvertible
extension VectorPoint: CustomStringConvertible {
    public var description: String {
        return "VectorPoint(x: (\(x.sign.rawValue), \(x.multiplier)), y: (\(y.sign.rawValue), \(y.multiplier)))"
    }
}

// MARK: - Equatable
extension VectorPoint: Equatable {
    public static func == (lhs: VectorPoint, rhs: VectorPoint) -> Bool {
        guard lhs.x.sign == rhs.x.sign else {
            return false
        }
        guard lhs.x.multiplier == rhs.x.multiplier else {
            return false
        }
        guard lhs.y.sign == rhs.y.sign else {
            return false
        }
        guard lhs.y.multiplier == rhs.y.multiplier else {
            return false
        }
        
        return true
    }
}

// MARK: - Instance Functionality
public extension VectorPoint {
    /// Calculates the `Point` for this instance in the specified `Rect`.
    func translate(to rect: Rect) -> Point {
        return translate(to: rect.size)
    }
    
    /// Calculates the `Point` in the desired output size
    func translate(to outputSize: Size) -> Point {
        let center = outputSize.center
        let radius = outputSize.minRadius
        
        switch (x.sign, y.sign) {
        case (.plus, .plus):
            return Point(x: center.x + (radius * x.multiplier), y: center.y + (radius * y.multiplier))
        case (.plus, .minus):
            return Point(x: center.x + (radius * x.multiplier), y: center.y - (radius * y.multiplier))
        case (.minus, .plus):
            return Point(x: center.x - (radius * x.multiplier), y: center.y + (radius * y.multiplier))
        case (.minus, .minus):
            return Point(x: center.x - (radius * x.multiplier), y: center.y - (radius * y.multiplier))
        }
    }
}
