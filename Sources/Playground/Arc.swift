//===----------------------------------------------------------------------===//
//
// Arc.swift
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

/// Arc of a circle (a continuous length around the circumference)
public struct Arc {
    public var startingDegree: CGFloat = 0.0
    public var endingDegree: CGFloat = 0.0
    public var radius: CGFloat = 0.0
    
    public init(startingDegree: CGFloat, endingDegree: CGFloat, radius: CGFloat) {
        self.startingDegree = startingDegree
        self.endingDegree = endingDegree
        self.radius = radius
    }
    
    public var startingGraphPoint: GraphPoint {
        return GraphPoint.graphPoint(forDegree: startingDegree, radius: radius)
    }
    
    public var endingGraphPoint: GraphPoint {
        return GraphPoint.graphPoint(forDegree: endingDegree, radius: radius)
    }
    
    /// Calculates the point of the right angle that joins the start and end points.
    public var pivot: GraphPoint {
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
