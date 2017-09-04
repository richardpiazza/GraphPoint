//===----------------------------------------------------------------------===//
//
// GraphPoint.swift
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

/// A point within a CGRect having coordinates as an offset of the `GraphOrigin`
///
/// ***For example:***
///
/// In CGRect(0, 0, 100, 100), the CGPoint(75, 25) would be translated to
/// GraphPoint(25, 25).
public typealias GraphPoint = CGPoint

public extension GraphPoint {
    /// The minimum radius of a circle that would contain this `GraphPoint`
    var minimumRadius: CGFloat {
        return max(x, y)
    }
    
    /// Uses the mathematical 'Law of Sines' to determine a `GraphPoint` for the supplied degree and radius
    ///
    /// - note: Degree 0 (zero) is the positive X axis and increments clockwise.
    public static func graphPoint(degree: CGFloat, radius: CGFloat) -> GraphPoint {
        var point = CGPoint.zero
        
        let angleRight = CGFloat(90)
        var angleRise = CGFloat(0)
        var angleRun = CGFloat(0)
        
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
    
    /// Uses the Pythagorean Theorem to solve for the x or y intercept given the
    /// supplied `GraphPoint` `sideA`.
    ///
    /// - note Degree 0 (zero) is the positive x axis and increments clockwise.
    public static func graphPoint(degree: CGFloat, radius: CGFloat, boundedBy sideA: GraphPoint) -> GraphPoint {
        var point = CGPoint.zero
        
        if (degree >= 315) {
            point.x = CGFloat(sqrtf(powf(Float(radius), 2) - powf(Float(sideA.y), 2)))
            point.y = sideA.y
        } else if (degree >= 270) {
            point.x = sideA.x
            point.y = CGFloat(sqrtf(powf(Float(radius), 2) - powf(Float(sideA.x), 2)))
        } else if (degree >= 225) {
            point.x = sideA.x
            point.y = CGFloat(sqrtf(powf(Float(radius), 2) - powf(Float(sideA.x), 2)))
        } else if (degree >= 180) {
            point.x = -CGFloat(sqrtf(powf(Float(radius), 2) - powf(Float(sideA.y), 2)))
            point.y = sideA.y
        } else if (degree >= 135) {
            point.x = -CGFloat(sqrtf(powf(Float(radius), 2) - powf(Float(sideA.y), 2)))
            point.y = sideA.y
        } else if (degree >= 90) {
            point.x = sideA.x
            point.y = -CGFloat(sqrtf(powf(Float(radius), 2) - powf(Float(sideA.x), 2)))
        } else if (degree >= 45) {
            point.x = sideA.x
            point.y = -CGFloat(sqrtf(powf(Float(radius), 2) - powf(Float(sideA.x), 2)))
        } else if (degree >= 0) {
            point.x = CGFloat(sqrtf(powf(Float(radius), 2) - powf(Float(sideA.y), 2)))
            point.y = sideA.y
        }
        
        return point
    }
    
    /// Uses the mathematical 'Law of Cotangents' to determine the degree for a `GraphPoint`
    ///
    /// - note: Degree 0 (zero) is the positive X axis and increments clockwise.
    public static func degree(graphPoint: GraphPoint) -> CGFloat {
        var degree = CGFloat(0)
        guard !graphPoint.equalTo(CGPoint.zero) else {
            return degree
        }
        
        if graphPoint.x >= 0 && graphPoint.y >= 0 {
            let midPoint = self.graphPoint(degree: CGFloat(315), radius: graphPoint.minimumRadius)
            if graphPoint.x <= midPoint.x {
                degree = CGFloat(270) + atan(graphPoint.x / graphPoint.y).degrees
            } else {
                degree = CGFloat(360) - atan(graphPoint.y / graphPoint.x).degrees
            }
        } else if graphPoint.x >= 0 && graphPoint.y <= 0 {
            let midPoint = self.graphPoint(degree: CGFloat(45), radius: graphPoint.minimumRadius)
            if graphPoint.x <= midPoint.x {
                degree = atan(abs(graphPoint.y) / graphPoint.x).degrees
            } else {
                degree = CGFloat(90) - atan(graphPoint.x / abs(graphPoint.y)).degrees
            }
        } else if graphPoint.x <= 0 && graphPoint.y <= 0 {
            let midPoint = self.graphPoint(degree: CGFloat(135), radius: graphPoint.minimumRadius)
            if graphPoint.x <= midPoint.x {
                degree = CGFloat(180) - atan(abs(graphPoint.y) / abs(graphPoint.x)).degrees
            } else {
                degree = CGFloat(90) + atan(abs(graphPoint.x) / abs(graphPoint.y)).degrees
            }
        } else if graphPoint.x <= 0 && graphPoint.y >= 0 {
            let midPoint = self.graphPoint(degree: CGFloat(225), radius: graphPoint.minimumRadius)
            if graphPoint.x <= midPoint.x {
                degree = CGFloat(180) + atan(graphPoint.y / abs(graphPoint.x)).degrees
            } else {
                degree = CGFloat(270) - atan(abs(graphPoint.x) / graphPoint.y).degrees
            }
        }
        
        return degree
    }
}
