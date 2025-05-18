/// Arc of a circle (a continuous length around the circumference)
public struct Arc: Hashable, Codable, Sendable {
    public var radius: Radius
    public var startingDegree: Degree
    public var endingDegree: Degree
    public var clockwise: Bool

    public init(
        radius: Radius = 0.0,
        startingDegree: Degree = 0.0,
        endingDegree: Degree = 0.0,
        clockwise: Bool = true
    ) {
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
            pivot = pivot
                .with(x: endingPoint.x)
                .with(y: startingPoint.y)
        } else if startingDegree < 180 {
            pivot = pivot
                .with(x: startingPoint.x)
                .with(y: endingPoint.y)
        } else if startingDegree < 270 {
            pivot = pivot
                .with(x: endingPoint.x)
                .with(y: startingPoint.y)
        } else {
            pivot = pivot
                .with(x: startingPoint.x)
                .with(y: endingPoint.y)
        }

        return pivot
    }
}
