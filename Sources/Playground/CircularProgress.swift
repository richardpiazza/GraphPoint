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
@IBDesignable open class CircularProgress: UIView {
    static fileprivate let startingDegree = CGFloat(270.0)
    static fileprivate let endingDegree = CGFloat(630.0)
    static fileprivate let degreesInCircle = Float(360.0)
    
    // MARK: - Value -
    
    /// The minimum value this control can have.
    open var minimumValue = Float(0.0)
    /// The maximum value this control can have.
    open var maximumValue = Float(1.0)
    /// The current value of the control (i.e. progress percentage).
    @IBInspectable open var value: Float = 0.0 {
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
    @IBInspectable open var clockwise: Bool = true {
        didSet {
            value = clockwise ? minimumValue : maximumValue
        }
    }
    /// The rate at which the progress is updated when using the `timerDate`.
    @IBInspectable open var refreshInterval: Float = 0.05
    fileprivate var initialDate: Date = Date()
    /// A date in the future which will be used to calculate the `value`.
    public var timerDate: Date? {
        didSet {
            guard let date = self.timerDate else {
                return
            }
            
            initialDate = Date()
            
            let order = date.compare(initialDate)
            if order == .orderedSame || order == .orderedAscending {
                value = maximumValue
                return
            }
            
            self.progress()
        }
    }
    
    // MARK: - Track -
    
    fileprivate var track = UIImageView(frame: CGRect.zero)
    /// The width of the outlining track.
    @IBInspectable open var trackWidth: Float = 1.0
    /// The color of the outlining track.
    @IBInspectable lazy open var trackColor: UIColor = {
        if let color = UIApplication.shared.keyWindow?.tintColor {
            return color.withAlphaComponent(0.5)
        }
        if let color = UIView.appearance().tintColor {
            return color.withAlphaComponent(0.5)
        }
        
        return UIColor.blue.withAlphaComponent(0.5)
    }()
    
    fileprivate var trackInnerRadius: CGFloat {
        return bounds.radius - CGFloat(trackWidth)
    }
    
    fileprivate var trackPath: CGMutablePath {
        return CGMutablePath.arcPath(inRect: bounds, startingDegree: type(of: self).startingDegree, endingDegree: type(of: self).endingDegree, innerRadius: trackInnerRadius, outerRadius: bounds.radius)
    }
    
    // MARK: - Fill -
    fileprivate var fill = UIImageView(frame: CGRect.zero)
    /// The width of the progress track.
    @IBInspectable open var fillWidth: Float = 3.0
    /// The color of the progress track.
    @IBInspectable lazy open var fillColor: UIColor = {
        if let color = UIApplication.shared.keyWindow?.tintColor {
            return color
        }
        if let color = UIView.appearance().tintColor {
            return color
        }
        return UIColor.blue
    }()
    
    fileprivate var fillInnerRadius: CGFloat {
        return bounds.radius - CGFloat(fillWidth)
    }
    
    fileprivate var fillPath: CGMutablePath {
        let endingDegree = CGFloat(Float(type(of: self).startingDegree) + (Float(type(of: self).degreesInCircle) * (value / maximumValue)))
        return CGMutablePath.arcPath(inRect: bounds, startingDegree: type(of: self).startingDegree, endingDegree: endingDegree, innerRadius: fillInnerRadius, outerRadius: bounds.radius)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = UIColor.clear
        
        if !self.subviews.contains(track) {
            self.addSubview(track)
        }
        
        if !self.subviews.contains(fill) {
            self.addSubview(fill)
        }
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        
        track.frame = bounds
        track.image = UIImage.filledImage(withPath: trackPath, color: trackColor, context: context)
        
        fill.frame = bounds
        fill.image = UIImage.filledImage(withPath: fillPath, color: fillColor, context: context)
        
        UIGraphicsEndImageContext()
    }
    
    /// Calculates the difference between the `initialDate` and the `timerDate`,
    /// then sets the `value` based on percent complete.
    public func progress() {
        guard let timerDate = self.timerDate else {
            return
        }
        
        let span = timerDate.timeIntervalSince(initialDate)
        let interval = Date().timeIntervalSince(initialDate)
        var percent = Float(interval / span)
        
        if clockwise {
            guard percent < maximumValue else {
                DispatchQueue.main.async(execute: {
                    self.value = self.maximumValue
                })
                return
            }
        } else {
            percent = maximumValue - percent
            guard percent > minimumValue else {
                DispatchQueue.main.async(execute: {
                    self.value = self.minimumValue
                })
                return
            }
        }
        
        value = percent
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(refreshInterval * Float(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            self.progress()
        }
    }
}
