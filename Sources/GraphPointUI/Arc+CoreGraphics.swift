import GraphPoint
#if canImport(CoreGraphics)
import CoreGraphics

public extension Arc {
    @available(*, deprecated, renamed: "startingPoint")
    var startingGraphPoint: GraphPoint {
        return GraphPoint.graphPoint(degree: CGFloat(startingDegree), radius: CGFloat(radius))
    }
    
    @available(*, deprecated, renamed: "endingPoint")
    var endingGraphPoint: GraphPoint {
        return GraphPoint.graphPoint(degree: CGFloat(endingDegree), radius: CGFloat(radius))
    }
    
    /// Calculates the point of the right angle that joins the start and end points.
    @available(*, deprecated, renamed: "pivotPoint")
    var pivot: GraphPoint {
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
