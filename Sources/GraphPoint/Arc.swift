/// Arc of a circle (a continuous length around the circumference)
public struct Arc {
    public var radius: Radius
    public var startingDegree: Degree
    public var endingDegree: Degree
    public var clockwise: Bool
    
    public init(radius: Radius, startingDegree: Degree, endingDegree: Degree, clockwise: Bool = true) {
        self.radius = radius
        self.startingDegree = startingDegree
        self.endingDegree = endingDegree
        self.clockwise = clockwise
    }
}

public extension Arc {
    /// The `CartesianPoint` that represents the starting point
    var startingPoint: CartesianPoint {
        guard let point = try? CartesianPoint.make(for: radius, degree: startingDegree) else {
            return .zero
        }
        
        return point
    }
    
    /// The `CartesianPoint` that represents the ending point
    var endingPoint: CartesianPoint {
        guard let point = try? CartesianPoint.make(for: radius, degree: endingDegree) else {
            return .zero
        }
        
        return point
    }
    
    /// Calculates the point of the right angle that joins the start and end points.
    var pivotPoint: CartesianPoint {
        var pivot = CartesianPoint(x: 0, y: 0)
        
        if startingDegree < 90 {
            pivot.x = endingPoint.x
            pivot.y = startingPoint.y
        } else if startingDegree < 180 {
            pivot.x = startingPoint.x
            pivot.y = endingPoint.y
        } else if startingDegree < 270 {
            pivot.x = endingPoint.x
            pivot.y = startingPoint.y
        } else {
            pivot.x = startingPoint.x
            pivot.y = endingPoint.y
        }
        
        return pivot
    }
}
