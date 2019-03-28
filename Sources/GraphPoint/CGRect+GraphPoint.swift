#if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS))

import CoreGraphics

public extension CGRect {
    /// The radius of a circle that fits within the bounds of the `CGRect`
    var radius: CGFloat {
        if self.midX > self.midY {
            return self.midY
        }
        
        return self.midX
    }
    
    /// Origin of a circle that fits within the bounds of the `CGRect`
    var graphOrigin: GraphOrigin {
        return CGPoint(x: self.midX, y: self.midY)
    }
    
    /// Translates an internal coordinate `CGPoint` to a `GraphPoint`
    func graphPoint(viewPoint: CGPoint) -> GraphPoint {
        var point = CGPoint.zero
        
        if viewPoint.x < graphOrigin.x {
            point.x = -(graphOrigin.x - viewPoint.x)
        } else if viewPoint.x > graphOrigin.x {
            point.x = viewPoint.x - graphOrigin.x
        }
        
        if viewPoint.y > graphOrigin.y {
            point.y = -(viewPoint.y - graphOrigin.y)
        } else if viewPoint.y < graphOrigin.y {
            point.y = graphOrigin.y - viewPoint.y
        }
        
        return point
    }
    
    /// Translates a `GraphPoint` to an internal coordinate `CGPoint`
    func point(graphPoint: GraphPoint) -> CGPoint {
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
    
    /// Convenience method that translates an internal coordinate point before passing to `degree(forGraphPoint:)`
    ///
    /// - note: Degree 0 (zero) is the positive X axis and increments clockwise.
    func degree(viewPoint: CGPoint) -> CGFloat {
        let graphPoint = self.graphPoint(viewPoint: viewPoint)
        return GraphPoint.degree(graphPoint: graphPoint)
    }
    
    /// Calculates the view frame for a `GraphFrame` contained with this frames bounds.
    /// An optional `GraphOriginOffset` allows for an offset value to change where center
    /// is calculated from.
    func frame(graphFrame: GraphFrame, offset: GraphOriginOffset = GraphOriginOffset(x: 0, y: 0)) -> CGRect {
        var graphCenter = self.graphOrigin
        graphCenter.x = graphCenter.x + offset.x
        graphCenter.y = graphCenter.y + offset.y
        
        return CGRect(x: graphCenter.x + graphFrame.origin.x, y: graphCenter.y - graphFrame.origin.y, width: graphFrame.width, height: graphFrame.height)
    }
}

#endif
