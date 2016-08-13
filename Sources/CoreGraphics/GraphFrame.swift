//===----------------------------------------------------------------------===//
//
// GraphFrame.swift
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
    
    /// Uses a `GraphFrame` origin (i.e. offset from center) to translate any
    /// `GraphPoint` into a `GraphFrame` bounds `CGPoint`
    ///
    /// ***For example:***
    ///
    /// Given: CGRect(0, 0, 500, 500) & GraphFrame(47.7022, 250.0, 197.7045, 202.2977),
    /// The GraphPoint(47.7022, 47.7022) would be translated to CGPoint(0.0, 202.2977)
    public func boundedPoint(forGraphPoint graphPoint: GraphPoint) -> CGPoint {
        let x = abs(origin.x - graphPoint.x)
        let y = abs(origin.y - graphPoint.y)
        
        return CGPoint(x: x, y: y)
    }
    
    /// Determines that smallest `GraphFrame` that encompases all graph points.
    public static func graphFrame(forGraphPoints graphPoints: [GraphPoint]) -> GraphFrame {
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
    public static func graphFrame(forGraphPoints graphPoints: [GraphPoint], radius: CGFloat, startDegree: CGFloat, endDegree: CGFloat) -> GraphFrame {
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
}
