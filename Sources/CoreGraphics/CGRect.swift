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
    
    /// Convenience method that translates an internal coordinate point before passing to `degree(forGraphPoint:)`
    ///
    /// - note: Degree 0 (zero) is the positive X axis and increments clockwise.
    public func degree(forPoint viewPoint: CGPoint) -> CGFloat {
        let graphPoint = self.graphPoint(forPoint: viewPoint)
        return GraphPoint.degree(forGraphPoint: graphPoint)
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


