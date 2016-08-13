//===----------------------------------------------------------------------===//
//
// CircularSlider.swift
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

import UIKit

@IBDesignable public class CircularSlider: UIControl {
    static private let startingDegree = CGFloat(270.0)
    static private let endingDegree = CGFloat(630.0)
    static private let degreesInCircle = Float(360.0)
    static private let minimumTouchSize = Float(44.0)
    static private let zeroDegreeOffset = Float(-90.0)
    
    // MARK: - Value -
    
    private var minimumValue = Float(0.0)
    private var maximumValue = Float(1.0)
    /// The current value of the control.
    @IBInspectable public var value: Float = 0.1 {
        didSet {
            if value > maximumValue {
                value = maximumValue
            } else if value < minimumValue {
                value = minimumValue
            }
            self.setNeedsLayout()
        }
    }
    
    // MARK: - Track -
    
    private var track = UIImageView(frame: CGRectZero)
    @IBInspectable var trackWidth: Float = 18.0
    @IBInspectable var trackColor: UIColor = {
        if let color = UIApplication.sharedApplication().keyWindow?.tintColor {
            return color.colorWithAlphaComponent(0.5)
        }
        if let color = UIView.appearance().tintColor {
            return color.colorWithAlphaComponent(0.5)
        }
        
        return UIColor.blueColor().colorWithAlphaComponent(0.5)
    }()
    
    // MARK: - Fill -
    
    private var fill = UIImageView(frame: CGRectZero)
    @IBInspectable var fillColor: UIColor = {
        if let color = UIApplication.sharedApplication().keyWindow?.tintColor {
            return color
        }
        if let color = UIView.appearance().tintColor {
            return color
        }
        
        return UIColor.blueColor()
    }()
    
    // MARK: - Ticks -
    
    private var ticks = UIImageView(frame: CGRectZero)
    @IBInspectable var numberOfTicks: Int = 360
    @IBInspectable var showsTicks: Bool = false
    @IBInspectable var lockToTicks: Bool = true
    @IBInspectable var tickWidth: Float = 0.5
    @IBInspectable var tickColor: UIColor = UIColor.whiteColor()
    
    private var tickDegrees: Float {
        return self.dynamicType.degreesInCircle / Float(numberOfTicks)
    }
    
    private var tickPercent: Float {
        return tickDegrees / self.dynamicType.degreesInCircle
    }
    
    // MARK: - Paths -
    
    private var touchRadius: CGFloat {
        return (trackWidth < Float(self.dynamicType.minimumTouchSize)) ? bounds.radius - CGFloat(self.dynamicType.minimumTouchSize) : bounds.radius - CGFloat(trackWidth)
    }
    
    private var innerRadius: CGFloat {
        return bounds.radius - CGFloat(trackWidth)
    }
    
    private var touchPath: CGMutablePathRef {
        return CGMutablePath.arcPath(inRect: bounds, startingDegree: self.dynamicType.startingDegree, endingDegree: self.dynamicType.endingDegree, innerRadius: touchRadius, outerRadius: bounds.radius)
    }
    
    private var trackPath: CGMutablePathRef {
        return CGMutablePath.arcPath(inRect: bounds, startingDegree: self.dynamicType.startingDegree, endingDegree: self.dynamicType.endingDegree, innerRadius: innerRadius, outerRadius: bounds.radius)
    }
    
    private var fillPath: CGMutablePathRef {
        let endingDegree = CGFloat(Float(self.dynamicType.startingDegree) + (Float(self.dynamicType.degreesInCircle) * (value / maximumValue)))
        return CGMutablePath.arcPath(inRect: bounds, startingDegree: self.dynamicType.startingDegree, endingDegree: endingDegree, innerRadius: innerRadius, outerRadius: bounds.radius)
    }
    
    private var tickPath: CGMutablePathRef? {
        guard showsTicks else {
            return nil
        }
        
        let path = CGPathCreateMutable()
        
        for i in 0...numberOfTicks {
            let degree = CGFloat(Float(i) * tickDegrees)
            let outerArc = Arc(startingDegree: degree, endingDegree: degree, radius: bounds.radius)
            let innerArc = Arc(startingDegree: degree, endingDegree: degree, radius: innerRadius)
            let outerPoint = outerArc.endingGraphPoint
            let innerPoint = innerArc.endingGraphPoint
            let origin = bounds.graphOrigin
            
            CGPathMoveToPoint(path, nil, origin.x + outerPoint.x, origin.y + outerPoint.y)
            CGPathAddLineToPoint(path, nil, origin.x + innerPoint.x, origin.y + innerPoint.y)
            CGPathCloseSubpath(path)
        }
        
        return path
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = UIColor.clearColor()
        
        if !self.subviews.contains(track) {
            self.addSubview(track)
        }
        
        if !self.subviews.contains(fill) {
            self.addSubview(fill)
        }
        
        if !self.subviews.contains(ticks) {
            self.addSubview(ticks)
        }
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.mainScreen().scale)
        let context = UIGraphicsGetCurrentContext()
        
        track.frame = bounds
        track.image = UIImage.filledImage(withPath: trackPath, color: trackColor, context: context)
        
        fill.frame = bounds
        fill.image = UIImage.filledImage(withPath: fillPath, color: fillColor, context: context)
        
        ticks.frame = bounds
        if let path = tickPath {
            ticks.hidden = false
            ticks.image = UIImage.strokedImage(withPath: path, color: tickColor, strokeWidth: CGFloat(tickWidth), context: context)
        } else {
            ticks.hidden = true
        }
        
        UIGraphicsEndImageContext()
    }
    
    public override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        return CGPathContainsPoint(touchPath, nil, point, false)
    }
    
    public override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let point = touch.locationInView(self)
        let degree = bounds.degree(forPoint: point)
        value = self.value(forDegree: degree)
        
        return super.beginTrackingWithTouch(touch, withEvent: event)
    }
    
    public override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let point = touch.locationInView(self)
        let degree = bounds.degree(forPoint: point)
        value = self.value(forDegree: degree)
        
        if value >= (maximumValue - tickPercent) {
            value = maximumValue
            return false
        } else if value <= (minimumValue + tickPercent) {
            value = minimumValue
            return false
        }
        
        return super.continueTrackingWithTouch(touch, withEvent: event)
    }
    
    /// Calculates the value (percent complete) for a specific degree.
    private func value(forDegree degree: CGFloat) -> Float {
        var percent: Float
        if degree == self.dynamicType.startingDegree {
            return minimumValue
        } else if degree > self.dynamicType.startingDegree {
            percent = Float((degree - self.dynamicType.startingDegree) / CGFloat(self.dynamicType.degreesInCircle))
        } else {
            percent = Float((degree + CGFloat(abs(self.dynamicType.zeroDegreeOffset))) / CGFloat(self.dynamicType.degreesInCircle))
        }
        
        if !lockToTicks {
            return percent
        }
        
        for i in 0...numberOfTicks {
            let tick = tickPercent * Float(i)
            if percent <= tick {
                return tick
            }
        }
        
        return maximumValue
    }
}
