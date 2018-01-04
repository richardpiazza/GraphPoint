#if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS))

import CoreGraphics

public extension CGMutablePath {
    public static func arcPath(inRect rect: CGRect, startingDegree: CGFloat, endingDegree: CGFloat, innerRadius: CGFloat, outerRadius: CGFloat) -> CGMutablePath {
        let innerArc = Arc(startingDegree: startingDegree, endingDegree: endingDegree, radius: innerRadius)
        let outerArc = Arc(startingDegree: startingDegree, endingDegree: endingDegree, radius: outerRadius)
        
        let path = CGMutablePath()
        path.addArc(center: rect.graphOrigin, radius: outerArc.radius, startAngle: startingDegree.radians, endAngle: endingDegree.radians, clockwise: false)
        path.addLine(to: CGPoint(x: rect.graphOrigin.x + innerArc.endingGraphPoint.x, y: rect.graphOrigin.y - innerArc.endingGraphPoint.y))
        path.addArc(center: rect.graphOrigin, radius: innerArc.radius, startAngle: endingDegree.radians, endAngle: startingDegree.radians, clockwise: true)
        path.closeSubpath()
        return path
    }
}

#endif
