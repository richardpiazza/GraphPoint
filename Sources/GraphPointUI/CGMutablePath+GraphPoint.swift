import GraphPoint
import Swift2D
#if canImport(CoreGraphics)
import CoreGraphics

public extension CGMutablePath {
    static func arcPath(inRect rect: CGRect, startingDegree: CGFloat, endingDegree: CGFloat, innerRadius: CGFloat, outerRadius: CGFloat) -> CGMutablePath {
        let innerArc = Arc(startingDegree: startingDegree, endingDegree: endingDegree, radius: innerRadius)
        let outerArc = Arc(startingDegree: startingDegree, endingDegree: endingDegree, radius: outerRadius)
        let startAngle = Degree(startingDegree)
        let endAngle = Degree(endingDegree)
        let cartesianOrigin = Rect(x: Float(rect.origin.x), y: Float(rect.origin.y), width: Float(rect.width), height: Float(rect.height)).cartesianOrigin
        let origin = CGPoint(cartesianOrigin)
        
        let path = CGMutablePath()
        path.addArc(center: origin, radius: outerArc.radius, startAngle: CGFloat(startAngle.radians), endAngle: CGFloat(endAngle.radians), clockwise: false)
        path.addLine(to: CGPoint(x: origin.x + CGFloat(innerArc.endingPoint.x), y: origin.y - CGFloat(innerArc.endingPoint.y)))
        path.addArc(center: origin, radius: innerArc.radius, startAngle: CGFloat(endAngle.radians), endAngle: CGFloat(startAngle.radians), clockwise: true)
        path.closeSubpath()
        return path
    }
}

#endif
