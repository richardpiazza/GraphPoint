#if (os(iOS) || os(tvOS))

import UIKit

/// An iOS Style circular slider
@IBDesignable open class CircularSlider: UIControl {
    static fileprivate let startingDegree = CGFloat(270.0)
    static fileprivate let endingDegree = CGFloat(630.0)
    static fileprivate let degreesInCircle = Float(360.0)
    static fileprivate let minimumTouchSize = Float(44.0)
    static fileprivate let zeroDegreeOffset = Float(-90.0)
    
    // MARK: - Value -
    
    open var minimumValue = Float(0.0)
    open var maximumValue = Float(1.0)
    /// The current value of the control.
    @IBInspectable open var value: Float = 0.1 {
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
    
    fileprivate var track = UIImageView(frame: CGRect.zero)
    @IBInspectable open var trackWidth: Float = 18.0
    @IBInspectable lazy open var trackColor: UIColor = {
        if let color = UIApplication.shared.keyWindow?.tintColor {
            return color.withAlphaComponent(0.5)
        }
        if let color = UIView.appearance().tintColor {
            return color.withAlphaComponent(0.5)
        }
        
        return UIColor.blue.withAlphaComponent(0.5)
    }()
    
    // MARK: - Fill -
    
    fileprivate var fill = UIImageView(frame: CGRect.zero)
    @IBInspectable lazy open var fillColor: UIColor = {
        if let color = UIApplication.shared.keyWindow?.tintColor {
            return color
        }
        if let color = UIView.appearance().tintColor {
            return color
        }
        
        return UIColor.blue
    }()
    
    // MARK: - Ticks -
    
    fileprivate var ticks = UIImageView(frame: CGRect.zero)
    @IBInspectable open var numberOfTicks: Int = 360
    @IBInspectable open var showsTicks: Bool = false
    @IBInspectable open var lockToTicks: Bool = true
    @IBInspectable open var tickWidth: Float = 0.5
    @IBInspectable open var tickColor: UIColor = UIColor.white
    
    fileprivate var tickDegrees: Float {
        return type(of: self).degreesInCircle / Float(numberOfTicks)
    }
    
    fileprivate var tickPercent: Float {
        return tickDegrees / type(of: self).degreesInCircle
    }
    
    // MARK: - Paths -
    
    fileprivate var touchRadius: CGFloat {
        return (trackWidth < Float(type(of: self).minimumTouchSize)) ? bounds.radius - CGFloat(type(of: self).minimumTouchSize) : bounds.radius - CGFloat(trackWidth)
    }
    
    fileprivate var innerRadius: CGFloat {
        return bounds.radius - CGFloat(trackWidth)
    }
    
    fileprivate var touchPath: CGMutablePath {
        return CGMutablePath.arcPath(inRect: bounds, startingDegree: type(of: self).startingDegree, endingDegree: type(of: self).endingDegree, innerRadius: touchRadius, outerRadius: bounds.radius)
    }
    
    fileprivate var trackPath: CGMutablePath {
        return CGMutablePath.arcPath(inRect: bounds, startingDegree: type(of: self).startingDegree, endingDegree: type(of: self).endingDegree, innerRadius: innerRadius, outerRadius: bounds.radius)
    }
    
    fileprivate var fillPath: CGMutablePath {
        let endingDegree = CGFloat(Float(type(of: self).startingDegree) + (Float(type(of: self).degreesInCircle) * (value / maximumValue)))
        return CGMutablePath.arcPath(inRect: bounds, startingDegree: type(of: self).startingDegree, endingDegree: endingDegree, innerRadius: innerRadius, outerRadius: bounds.radius)
    }
    
    fileprivate var tickPath: CGMutablePath? {
        guard showsTicks else {
            return nil
        }
        
        let path = CGMutablePath()
        
        for i in 0...numberOfTicks {
            let degree = CGFloat(Float(i) * tickDegrees)
            let outerArc = Arc(startingDegree: degree, endingDegree: degree, radius: bounds.radius)
            let innerArc = Arc(startingDegree: degree, endingDegree: degree, radius: innerRadius)
            let outerPoint = outerArc.endingGraphPoint
            let innerPoint = innerArc.endingGraphPoint
            let origin = bounds.graphOrigin
            
            path.move(to: CGPoint(x: origin.x + outerPoint.x, y: origin.y + outerPoint.y))
            path.addLine(to: CGPoint(x: origin.x + innerPoint.x, y: origin.y + innerPoint.y))
            path.closeSubpath()
        }
        
        return path
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
        
        if !self.subviews.contains(ticks) {
            self.addSubview(ticks)
        }
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        
        track.frame = bounds
        track.image = UIImage.filledImage(withPath: trackPath, color: trackColor, context: context)
        
        fill.frame = bounds
        fill.image = UIImage.filledImage(withPath: fillPath, color: fillColor, context: context)
        
        ticks.frame = bounds
        if let path = tickPath {
            ticks.isHidden = false
            ticks.image = UIImage.strokedImage(withPath: path, color: tickColor, strokeWidth: CGFloat(tickWidth), context: context)
        } else {
            ticks.isHidden = true
        }
        
        UIGraphicsEndImageContext()
    }
    
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return touchPath.contains(point)
    }
    
    open override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let point = touch.location(in: self)
        let degree = bounds.degree(viewPoint: point)
        value = self.value(forDegree: degree)
        
        return super.beginTracking(touch, with: event)
    }
    
    open override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let point = touch.location(in: self)
        let degree = bounds.degree(viewPoint: point)
        value = self.value(forDegree: degree)
        
        if value >= (maximumValue - tickPercent) {
            value = maximumValue
            return false
        } else if value <= (minimumValue + tickPercent) {
            value = minimumValue
            return false
        }
        
        return super.continueTracking(touch, with: event)
    }
    
    /// Calculates the value (percent complete) for a specific degree.
    fileprivate func value(forDegree degree: CGFloat) -> Float {
        var percent: Float
        if degree == type(of: self).startingDegree {
            return minimumValue
        } else if degree > type(of: self).startingDegree {
            percent = Float((degree - type(of: self).startingDegree) / CGFloat(type(of: self).degreesInCircle))
        } else {
            percent = Float((degree + CGFloat(abs(type(of: self).zeroDegreeOffset))) / CGFloat(type(of: self).degreesInCircle))
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

#endif
