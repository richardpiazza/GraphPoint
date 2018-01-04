#if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS))

import CoreGraphics

/// Arc of a circle (a continuous length around the circumference)
public struct Arc {
    public var startingDegree: CGFloat = 0.0
    public var endingDegree: CGFloat = 0.0
    public var radius: CGFloat = 0.0
    
    public init(startingDegree: CGFloat, endingDegree: CGFloat, radius: CGFloat) {
        self.startingDegree = startingDegree
        self.endingDegree = endingDegree
        self.radius = radius
    }
    
    public var startingGraphPoint: GraphPoint {
        return GraphPoint.graphPoint(degree: startingDegree, radius: radius)
    }
    
    public var endingGraphPoint: GraphPoint {
        return GraphPoint.graphPoint(degree: endingDegree, radius: radius)
    }
    
    /// Calculates the point of the right angle that joins the start and end points.
    public var pivot: GraphPoint {
        var pivot = GraphPoint(x: 0, y: 0)
        
        if startingDegree < 90 {
            pivot.x = endingGraphPoint.x
            pivot.y = startingGraphPoint.y
        } else if startingDegree < 180 {
            pivot.x = startingGraphPoint.x
            pivot.y = endingGraphPoint.y
        } else if startingDegree < 270 {
            pivot.x = endingGraphPoint.x
            pivot.y = startingGraphPoint.y
        } else {
            pivot.x = startingGraphPoint.x
            pivot.y = endingGraphPoint.y
        }
        
        return pivot
    }
}

#endif
