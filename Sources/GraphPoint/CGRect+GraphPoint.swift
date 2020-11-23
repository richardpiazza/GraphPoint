#if canImport(CoreGraphics)
import CoreGraphics

public extension CGRect {
    /// The radius of the largest circle that fits within the bounds of the `CGRect`
    @available(*, deprecated, renamed: "CartesianPlane.minimumAxis")
    var radius: CGFloat {
        return min(midX, midY)
    }
    
    /// Origin of the largest circle that fits within the bounds of the `CGRect`
    @available(*, deprecated, renamed: "CartesianPlane.cartesianOrigin")
    var graphOrigin: GraphOrigin {
        return CGPoint(x: midX, y: midY)
    }
    
    /// Translates an _internal_ coordinate `CGPoint` to the cartesian based `GraphPoint`.
    ///
    /// - parameter point: A point within the instance `CGRect`
    /// - returns: Cartesian coordinates for the supplied point.
    @available(*, deprecated, renamed: "CartesianPlane.cartesianPoint(for:)")
    func graphPoint(for point: CGPoint) -> GraphPoint {
        var graphPoint = CGPoint.zero
        
        if point.x < graphOrigin.x {
            graphPoint.x = -(graphOrigin.x - point.x)
        } else if point.x > graphOrigin.x {
            graphPoint.x = point.x - graphOrigin.x
        }
        
        if point.y > graphOrigin.y {
            graphPoint.y = -(point.y - graphOrigin.y)
        } else if point.y < graphOrigin.y {
            graphPoint.y = graphOrigin.y - point.y
        }
        
        return graphPoint
    }
    
    /// Translates cartesian-based `GraphPoint` coordinates to an _internal_ coordinate `CGPoint`.
    ///
    /// - parameter graphPoint: The cartesian coordinates to translate
    /// - returns: Translated point within the instance `CGRect`
    func point(for graphPoint: GraphPoint) -> CGPoint {
        var point = CGPoint.zero
        
        if graphPoint.x >= 0 {
            point.x = graphOrigin.x + graphPoint.x
        } else {
            point.x = graphOrigin.x - abs(graphPoint.x)
        }
        
        if graphPoint.y <= 0 {
            point.y = graphOrigin.y + abs(graphPoint.y)
        } else {
            point.y = graphOrigin.y - graphPoint.y
        }
        
        return point
    }
    
    /// Calculates the circular angle for an _internal_ coordinate `CGPoint`.
    ///
    /// First translates the internal coordinate to the cartesian-based `GraphPoint`,
    /// then returns the result from `GraphPoint.degree(for:)`.
    ///
    /// - note: Degree 0 (zero) is the positive X axis and increments clockwise.
    ///
    /// - parameter point: A point within the instance `CGRect`
    /// - returns: Angle between 0° and 360°
    func degree(for point: CGPoint) -> CGFloat {
        let graphPoint = self.graphPoint(for: point)
        return GraphPoint.degree(graphPoint: graphPoint)
    }
    
    /// Calculates the _internal_ frame for a `GraphFrame` contained with the `CGRect` bounds.
    ///
    /// An optional `GraphOriginOffset` allows for an offset value to change where center
    /// is calculated from.
    ///
    /// - parameter graphFrame: Cartesian coordinated frame within this instance
    /// - parameter offset: The offset used for the provided `GraphFrame`. Typically this is (0, 0).
    func frame(for graphFrame: GraphFrame, offset: GraphPoint = GraphPoint(x: 0, y: 0)) -> CGRect {
        var graphCenter = self.graphOrigin
        graphCenter.x = graphCenter.x + offset.x
        graphCenter.y = graphCenter.y + offset.y
        
        return CGRect(x: graphCenter.x + graphFrame.origin.x, y: graphCenter.y - graphFrame.origin.y, width: graphFrame.width, height: graphFrame.height)
    }
}

public extension CGRect {
    @available(*, deprecated, renamed: "graphPoint(for:)")
    func graphPoint(viewPoint: CGPoint) -> GraphPoint {
        return graphPoint(for: viewPoint)
    }
    
    @available(*, deprecated, renamed: "point(for:)")
    func point(graphPoint: GraphPoint) -> CGPoint {
        return point(for: graphPoint)
    }
    
    @available(*, deprecated, renamed: "degree(for:)")
    func degree(viewPoint: CGPoint) -> CGFloat {
        return degree(for: viewPoint)
    }
    
    @available(*, deprecated, renamed: "frame(for:offset:)")
    func frame(graphFrame: GraphFrame, offset: GraphOriginOffset = GraphOriginOffset(x: 0, y: 0)) -> CGRect {
        return frame(for: graphFrame, offset: offset)
    }
}

#endif
