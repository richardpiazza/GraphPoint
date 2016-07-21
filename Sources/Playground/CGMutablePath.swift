//===----------------------------------------------------------------------===//
//
// CGMutablePath.swift
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

extension CGMutablePath {
    static func arcPath(inRect rect: CGRect, startingDegree: CGFloat, endingDegree: CGFloat, innerRadius: CGFloat, outerRadius: CGFloat) -> CGMutablePathRef {
        let innerArc = Arc(startingDegree: startingDegree, endingDegree: endingDegree, radius: innerRadius)
        let outerArc = Arc(startingDegree: startingDegree, endingDegree: endingDegree, radius: outerRadius)
        
        let path = CGPathCreateMutable()
        CGPathAddArc(path, nil, rect.graphOrigin.x, rect.graphOrigin.y, outerArc.radius, startingDegree.radians, endingDegree.radians, false)
        CGPathAddLineToPoint(path, nil, rect.graphOrigin.x + innerArc.endingGraphPoint(inRect: rect).x, rect.graphOrigin.y - innerArc.endingGraphPoint(inRect: rect).y)
        CGPathAddArc(path, nil, rect.graphOrigin.x, rect.graphOrigin.y, innerArc.radius, endingDegree.radians, startingDegree.radians, true)
        CGPathCloseSubpath(path)
        return path
    }
}
