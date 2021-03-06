#if canImport(CoreGraphics)
import CoreGraphics

/// A area within a `CGRect` that has an `Origin` relative to the `GraphOrigin`.
/// The area will have an origin based on the cartesian coordinate system.
///
/// For example:
///
/// * Given: **CGRect(0, 0, 100, 100)**
/// *  with: **GraphOrigin(50, 50)**
/// *   the: **CGRect(10, 10, 10, 10)**
/// *   has: **GraphFrame(-40, 40, 10, 10)**
@available(*, deprecated, renamed: "CartesianFrame")
public typealias GraphFrame = CGRect

@available(*, deprecated, renamed: "CartesianFrame")
public extension GraphFrame {
    /// The offset to the `GraphOrigin`
    @available(*, deprecated, renamed: "CartesianFrame.offsetToCartesianOrigin")
    var graphOriginOffset: GraphPoint {
        if origin.x <= 0 {
            return GraphPoint(x: abs(origin.x), y: origin.y)
        } else {
            return GraphPoint(x: -(origin.x), y: origin.y)
        }
    }
    
    /// Uses a `GraphFrame` origin (i.e. offset from center) to translate any
    /// `GraphPoint` into a `GraphFrame` bounds `CGPoint`
    ///
    /// ***For example:***
    ///
    /// Given: CGRect(0, 0, 500, 500) & GraphFrame(47.7022, 250.0, 197.7045, 202.2977),
    /// The GraphPoint(47.7022, 47.7022) would be translated to CGPoint(0.0, 202.2977)
    @available(*, deprecated)
    func boundedPoint(graphPoint: GraphPoint) -> CGPoint {
        let x = abs(origin.x - graphPoint.x)
        let y = abs(origin.y - graphPoint.y)
        
        return CGPoint(x: x, y: y)
    }
    
    /// Determines that smallest `GraphFrame` that encompasses all graph points.
    @available(*, deprecated, renamed: "CartesianFrame.make(for:)")
    static func graphFrame(graphPoints: [GraphPoint]) -> GraphFrame {
        var minXMaxY = CGPoint.zero
        var maxXMinY = CGPoint.zero
        
        for point in graphPoints {
            if point.x < minXMaxY.x || minXMaxY.x == 0 {
                minXMaxY.x = point.x
            }
            if point.y > minXMaxY.y || minXMaxY.y == 0 {
                minXMaxY.y = point.y
            }
            if point.x > maxXMinY.x || maxXMinY.x == 0 {
                maxXMinY.x = point.x
            }
            if point.y < maxXMinY.y || maxXMinY.y == 0 {
                maxXMinY.y = point.y
            }
        }
        
        return GraphFrame(x: minXMaxY.x, y: minXMaxY.y, width: abs(maxXMinY.x - minXMaxY.x), height: abs(maxXMinY.y - minXMaxY.y))
    }
    
    /// Determines the smallest `GraphFrame` that encompasses all points, with
    /// expansion for crossing an axis.
    @available(*, deprecated, renamed: "CartesianFrame.make(for:points:)")
    static func graphFrame(graphPoints: [GraphPoint], radius: CGFloat, startDegree: CGFloat, endDegree: CGFloat) -> GraphFrame {
        var graphFrame = self.graphFrame(graphPoints: graphPoints)
        
        if (startDegree >= 270 && startDegree <= 360) && (endDegree >= 0 && endDegree <= 90) {
            let exterior = graphFrame.origin.x + graphFrame.width
            if exterior < radius {
                let expansion = radius - exterior
                graphFrame.size.width = graphFrame.size.width + expansion
            }
        } else if (startDegree >= 180 && startDegree <= 270) && (endDegree >= 270 && endDegree <= 360) {
            let exterior = graphFrame.origin.y
            if exterior < radius {
                let expansion = radius - exterior
                graphFrame.origin.y = graphFrame.origin.y + expansion
                graphFrame.size.height = graphFrame.size.height + expansion
            }
        } else if (startDegree >= 90 && startDegree <= 180) && (endDegree >= 180 && endDegree <= 270) {
            let exterior = abs(graphFrame.origin.x)
            if exterior < radius {
                let expansion = radius - exterior
                graphFrame.origin.x = graphFrame.origin.x - expansion
                graphFrame.size.width = graphFrame.size.width + expansion
            }
        } else if (startDegree >= 0 && startDegree <= 90) && (endDegree >= 90 && endDegree <= 180) {
            let exterior = abs(graphFrame.origin.y) + graphFrame.height
            if exterior < radius {
                let expansion = radius - exterior
                graphFrame.size.height = graphFrame.size.height + expansion
            }
        }
        
        return graphFrame
    }
}

#endif
