//===----------------------------------------------------------------------===//
//
// CircularProgress.swift
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

/// An iOS Style circular progress indicator.
/// Includes a `timerDate` variable which can be used to show progress over a
/// timed period.
@IBDesignable public class CircularProgress: UIView {
    static private let startingDegree = CGFloat(270.0)
    static private let endingDegree = CGFloat(630.0)
    static private let degreesInCircle = Float(360.0)
    
    // MARK: - Value -
    
    /// The minimum value this control can have.
    private var minimumValue = Float(0.0)
    /// The maximum value this control can have.
    private var maximumValue = Float(1.0)
    /// The current value of the control (i.e. progress percentage).
    @IBInspectable public var value: Float = 0.0 {
        didSet {
            if value > maximumValue {
                value = maximumValue
            } else if value < minimumValue {
                value = minimumValue
            }
            self.setNeedsLayout()
        }
    }
    
    // MARK: - Timer -
    
    /// Determines the fill direction
    @IBInspectable public var clockwise: Bool = true {
        didSet {
            value = clockwise ? 0.0 : 1.0
        }
    }
    /// The rate at which the progress is updated when using the `timerDate`.
    @IBInspectable public var refreshInterval: Float = 0.05
    private var initialDate: NSDate = NSDate()
    /// A date in the future which will be used to calculate the `value`.
    public var timerDate: NSDate? {
        didSet {
            guard let date = self.timerDate else {
                return
            }
            
            initialDate = NSDate()
            
            let order = date.compare(initialDate)
            if order == .OrderedSame || order == .OrderedAscending {
                value = maximumValue
                return
            }
            
            self.progress()
        }
    }
    
    // MARK: - Track -
    
    private var track = UIImageView(frame: CGRectZero)
    /// The width of the outlining track.
    @IBInspectable public var trackWidth: Float = 1.0
    /// The color of the outlining track.
    @IBInspectable lazy public var trackColor: UIColor = {
        if let color = UIApplication.sharedApplication().keyWindow?.tintColor {
            return color.colorWithAlphaComponent(0.5)
        }
        if let color = UIView.appearance().tintColor {
            return color.colorWithAlphaComponent(0.5)
        }
        
        return UIColor.blueColor().colorWithAlphaComponent(0.5)
    }()
    
    private var trackInnerRadius: CGFloat {
        return bounds.radius - CGFloat(trackWidth)
    }
    
    private var trackPath: CGMutablePathRef {
        return CGMutablePath.arcPath(inRect: bounds, startingDegree: self.dynamicType.startingDegree, endingDegree: self.dynamicType.endingDegree, innerRadius: trackInnerRadius, outerRadius: bounds.radius)
    }
    
    // MARK: - Fill -
    private var fill = UIImageView(frame: CGRectZero)
    /// The width of the progress track.
    @IBInspectable public var fillWidth: Float = 3.0
    /// The color of the progress track.
    @IBInspectable lazy public var fillColor: UIColor = {
        if let color = UIApplication.sharedApplication().keyWindow?.tintColor {
            return color
        }
        if let color = UIView.appearance().tintColor {
            return color
        }
        return UIColor.blueColor()
    }()
    
    private var fillInnerRadius: CGFloat {
        return bounds.radius - CGFloat(fillWidth)
    }
    
    private var fillPath: CGMutablePathRef {
        let endingDegree = CGFloat(Float(self.dynamicType.startingDegree) + (Float(self.dynamicType.degreesInCircle) * (value / maximumValue)))
        return CGMutablePath.arcPath(inRect: bounds, startingDegree: self.dynamicType.startingDegree, endingDegree: endingDegree, innerRadius: fillInnerRadius, outerRadius: bounds.radius)
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
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.mainScreen().scale)
        let context = UIGraphicsGetCurrentContext()
        
        track.frame = bounds
        track.image = UIImage.filledImage(withPath: trackPath, color: trackColor, context: context)
        
        fill.frame = bounds
        fill.image = UIImage.filledImage(withPath: fillPath, color: fillColor, context: context)
        
        UIGraphicsEndImageContext()
    }
    
    /// Calculates the difference between the `initialDate` and the `timerDate`,
    /// then sets the `value` based on percent complete.
    private func progress() {
        guard let timerDate = self.timerDate else {
            return
        }
        
        let span = timerDate.timeIntervalSinceDate(initialDate)
        let interval = NSDate().timeIntervalSinceDate(initialDate)
        var percent = Float(interval / span)
        
        if clockwise {
            guard percent < maximumValue else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.value = self.maximumValue
                })
                return
            }
        } else {
            percent = maximumValue - percent
            guard percent > minimumValue else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.value = self.minimumValue
                })
                return
            }
        }
        
        value = percent
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(refreshInterval * Float(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            self.progress()
        }
    }
}
