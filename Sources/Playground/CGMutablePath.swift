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
