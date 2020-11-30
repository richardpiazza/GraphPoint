import GraphPoint
import Swift2D
#if canImport(CoreGraphics)
import CoreGraphics

@available(*, deprecated, message: "GraphPointUI will be removed in the next version.")
public extension CGMutablePath {
    static func arcPath(inRect rect: CGRect, startingDegree: CGFloat, endingDegree: CGFloat, innerRadius: CGFloat, outerRadius: CGFloat) -> CGMutablePath {
        let startAngle = Degree(startingDegree)
        let endAngle = Degree(endingDegree)
        
        let innerArc = Arc(radius: Radius(innerRadius), startingDegree: startAngle, endingDegree: endAngle)
        let outerArc = Arc(radius: Radius(outerRadius), startingDegree: startAngle, endingDegree: endAngle)
        
        let origin = CGPoint(Rect(rect).cartesianOrigin)
        
        let path = CGMutablePath()
        path.addArc(center: origin, radius: CGFloat(outerArc.radius), startAngle: CGFloat(startAngle.radians), endAngle: CGFloat(endAngle.radians), clockwise: false)
        path.addLine(to: CGPoint(x: origin.x + CGFloat(innerArc.endingPoint.x), y: origin.y - CGFloat(innerArc.endingPoint.y)))
        path.addArc(center: origin, radius: CGFloat(innerArc.radius), startAngle: CGFloat(endAngle.radians), endAngle: CGFloat(startAngle.radians), clockwise: true)
        path.closeSubpath()
        return path
    }
}

#endif
