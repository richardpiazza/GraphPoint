//===----------------------------------------------------------------------===//
//
// CGRect.swift
//
// Copyright (c) 2016 Richard Piazza
// https://github.com/richardpiazza/GraphPoint
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
//===----------------------------------------------------------------------===//

import CoreGraphics

public extension CGRect {
    /// The radius of a circle that fits within the bounds of the `CGRect`
    public var radius: CGFloat {
        if self.midX > self.midY {
            return self.midY
        }
        
        return self.midX
    }
    
    /// Origin of a circle that fits within the bounds of the `CGRect`
    public var graphOrigin: GraphOrigin {
        return CGPointMake(self.midX, self.midY)
    }
    
    /// Translates an internal coordinate `CGPoint` to a `GraphPoint`
    public func graphPoint(forPoint viewPoint: CGPoint) -> GraphPoint {
        var point = CGPointZero
        
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
    public func point(forGraphPoint graphPoint: GraphPoint) -> CGPoint {
        var point = CGPointZero
        
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
    
    /// Uses the mathematical 'Law of Sines' to determine a `GraphPoint` for the supplied degree and radius
    ///
    /// - note: Degree 0 (zero) is the positive X axis and increments clockwise.
    public func graphPoint(forDegree degree: CGFloat, radius r: CGFloat? = nil) -> GraphPoint {
        var point = CGPointZero
        
        let angleRight = CGFloat(90)
        var angleRise = CGFloat(0)
        var angleRun = CGFloat(0)
        
        let radius = r ?? self.radius
        
        if (degree > 315) {
            angleRise = CGFloat(360) - degree
            angleRun = CGFloat(180) - angleRight - angleRise
            point.y = (radius / sin(angleRight.radians)) * sin(angleRise.radians)
            point.x = (radius / sin(angleRight.radians)) * sin(angleRun.radians)
        } else if (degree > 270) {
            angleRun = degree - CGFloat(270)
            angleRise = CGFloat(180) - angleRight - angleRun
            point.y = (radius / sin(angleRight.radians)) * sin(angleRise.radians)
            point.x = (radius / sin(angleRight.radians)) * sin(angleRun.radians)
        } else if (degree > 225) {
            angleRun = CGFloat(270) - degree
            angleRise = CGFloat(180) - angleRight - angleRun
            point.y = (radius / sin(angleRight.radians)) * sin(angleRise.radians)
            point.x = -1.0 * (radius / sin(angleRight.radians)) * sin(angleRun.radians)
        } else if (degree > 180) {
            angleRise = degree - CGFloat(180)
            angleRun = CGFloat(180) - angleRight - angleRise
            point.y = (radius / sin(angleRight.radians)) * sin(angleRise.radians)
            point.x = -1.0 * (radius / sin(angleRight.radians)) * sin(angleRun.radians)
        } else if (degree > 135) {
            angleRise = CGFloat(180) - degree
            angleRun = CGFloat(180) - angleRight - angleRise
            point.y = -1.0 * (radius / sin(angleRight.radians)) * sin(angleRise.radians)
            point.x = -1.0 * (radius / sin(angleRight.radians)) * sin(angleRun.radians)
        } else if (degree > 90) {
            angleRun = degree - CGFloat(90)
            angleRise = CGFloat(180) - angleRight - angleRun
            point.y = -1.0 * (radius / sin(angleRight.radians)) * sin(angleRise.radians)
            point.x = -1.0 * (radius / sin(angleRight.radians)) * sin(angleRun.radians)
        } else if (degree > 45) {
            angleRun = CGFloat(90) - degree
            angleRise = CGFloat(180) - angleRight - angleRun
            point.y = -1.0 * (radius / sin(angleRight.radians)) * sin(angleRise.radians)
            point.x = (radius / sin(angleRight.radians)) * sin(angleRun.radians)
        } else if (degree >= 0) {
            angleRise = degree
            angleRun = CGFloat(180) - angleRight - angleRise
            point.y = -1.0 * (radius / sin(angleRight.radians)) * sin(angleRise.radians)
            point.x = (radius / sin(angleRight.radians)) * sin(angleRun.radians)
        }
        
        return point
    }
    
    /// Uses the mathematical 'Law of Cotangents' to determine the degree for a `GraphPoint`
    ///
    /// - note: Degree 0 (zero) is the positive X axis and increments clockwise.
    public func degree(forGraphPoint graphPoint: GraphPoint) -> CGFloat {
        var degree = CGFloat(0)
        guard !CGPointEqualToPoint(graphPoint, CGPointZero) else {
            return degree
        }
        
        if graphPoint.x >= 0 && graphPoint.y >= 0 {
            let midPoint = self.graphPoint(forDegree: CGFloat(315))
            if graphPoint.x <= midPoint.x {
                degree = CGFloat(270) + atan(graphPoint.x / graphPoint.y).degrees
            } else {
                degree = CGFloat(360) - atan(graphPoint.y / graphPoint.x).degrees
            }
        } else if graphPoint.x >= 0 && graphPoint.y <= 0 {
            let midPoint = self.graphPoint(forDegree: CGFloat(45))
            if graphPoint.x <= midPoint.x {
                degree = atan(abs(graphPoint.y) / graphPoint.x).degrees
            } else {
                degree = CGFloat(90) - atan(graphPoint.x / abs(graphPoint.y)).degrees
            }
        } else if graphPoint.x <= 0 && graphPoint.y <= 0 {
            let midPoint = self.graphPoint(forDegree: CGFloat(135))
            if graphPoint.x <= midPoint.x {
                degree = CGFloat(180) - atan(abs(graphPoint.y) / abs(graphPoint.x)).degrees
            } else {
                degree = CGFloat(90) + atan(abs(graphPoint.x) / abs(graphPoint.y)).degrees
            }
        } else if graphPoint.x <= 0 && graphPoint.y >= 0 {
            let midPoint = self.graphPoint(forDegree: CGFloat(225))
            if graphPoint.x <= midPoint.x {
                degree = CGFloat(180) + atan(graphPoint.y / abs(graphPoint.x)).degrees
            } else {
                degree = CGFloat(270) - atan(abs(graphPoint.x) / graphPoint.y).degrees
            }
        }
        
        return degree
    }
    
    /// Convenience method that translates an internal coordinate point before passing to `degree(forGraphPoint:)`
    ///
    /// - note: Degree 0 (zero) is the positive X axis and increments clockwise.
    public func degree(forPoint viewPoint: CGPoint) -> CGFloat {
        let graphPoint = self.graphPoint(forPoint: viewPoint)
        return degree(forGraphPoint: graphPoint)
    }
    
    /// Determines that smallest `GraphFrame` that encompases all graph points.
    public func graphFrame(forGraphPoints graphPoints: [GraphPoint]) -> GraphFrame {
        var minXMaxY = CGPointZero
        var maxXMinY = CGPointZero
        
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
    
    /// Determines the smallest `GraphFrame` that encompases all points, with
    /// expansion for crossing an axis.
    public func graphFrame(forGraphPoints graphPoints: [GraphPoint], radius: CGFloat, startDegree: CGFloat, endDegree: CGFloat) -> GraphFrame {
        var graphFrame = self.graphFrame(forGraphPoints: graphPoints)
        
        if startDegree >= 270 && endDegree <= 90 {
            let expand = abs(graphFrame.origin.x + graphFrame.width)
            if expand < radius {
                graphFrame.size.width = graphFrame.size.width + (radius - expand)
            }
        } else if startDegree >= 180 && endDegree > 270 {
            let expand = abs(graphFrame.origin.y)
            if expand < radius {
                graphFrame.origin.y = graphFrame.origin.y + (radius - expand)
                graphFrame.size.height = graphFrame.size.height + (radius - expand)
            }
        } else if startDegree >= 90 && endDegree > 180 {
            let expand = abs(graphFrame.origin.x)
            if expand < radius {
                graphFrame.origin.x = graphFrame.origin.x - (radius - expand)
                graphFrame.size.width = graphFrame.size.width + (radius - expand)
            }
        } else if startDegree >= 0 && endDegree > 90 {
            let expand = abs(graphFrame.origin.y + graphFrame.height)
            if expand < radius {
                graphFrame.size.height = graphFrame.size.height + (radius - expand)
            }
        }
        
        return graphFrame
    }
    
    /// Calculates the view frame for a `GraphFrame` contained with this frames bounds.
    /// An optional `GraphOriginOffset` allows for an offset value to change where center
    /// is calculated from.
    public func frame(forGraphFrame graphFrame: GraphFrame, graphOriginOffset: GraphOriginOffset? = nil) -> CGRect {
        let originOffset = graphOriginOffset ?? GraphOriginOffset(x: 0, y: 0)
        
        var graphCenter = self.graphOrigin
        graphCenter.x = graphCenter.x + originOffset.x
        graphCenter.y = graphCenter.y + originOffset.y
        
        return CGRect(x: graphCenter.x + graphFrame.origin.x, y: graphCenter.y - graphFrame.origin.y, width: graphFrame.width, height: graphFrame.height)
    }
}

/// A frame within a `CGRect` that has an `Origin` relative to the `GraphOrigin`.
///
/// ***For example:***
///
/// In CGRect(0, 0, 100, 100) with GraphOrigin(50, 50), a CGRect(10, 10, 10, 10)
/// would have a GraphFrame(-40, 40, 10, 10)
public typealias GraphFrame = CGRect

public extension GraphFrame {
    /// The offset to the `GraphOrigin`
    public var graphOriginOffset: GraphOriginOffset {
        if origin.x <= 0 {
            return GraphOriginOffset(x: abs(origin.x), y: origin.y)
        } else {
            return GraphOriginOffset(x: -(origin.x), y: origin.y)
        }
    }
}
