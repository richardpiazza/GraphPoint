#if (os(iOS) || os(tvOS))

import UIKit

/// An iOS Style circular progress indicator.
/// Includes a `timerDate` variable which can be used to show progress over a
/// timed period.
@IBDesignable open class CircularProgress: UIView {
    static fileprivate let startingDegree = CGFloat(270.0)
    static fileprivate let endingDegree = CGFloat(630.0)
    static fileprivate let degreesInCircle = Float(360.0)
    
    public typealias ExpiredCompletion = () -> Void
    
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
    @IBInspectable open var refreshInterval: Float = 0.0333
    /// An interval of time, once specified, will be used to calculate the `value`.
    public var timeInterval: TimeInterval? {
        didSet {
            guard let interval = self.timeInterval else {
                return
            }
            
            guard interval > 0 else {
                value = maximumValue
                return
            }
            
            completedIntervals = 0
            resume()
        }
    }
    fileprivate var completedIntervals: TimeInterval = 0.0
    fileprivate var referenceDate: Date?
    fileprivate var expiredCompletion: ExpiredCompletion?
    /// Reports the status of the automatic refresh.
    public var isActive: Bool {
        return referenceDate != nil
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
    
    /// Calculates the number of completed intervals and sets the `value`
    /// based on the percent complete.
    private func updateProgress() {
        guard let timeInterval = self.timeInterval else {
            return
        }
        
        guard let referenceDate = self.referenceDate else {
            return
        }
        
        completedIntervals = Date().timeIntervalSince(referenceDate)
        var percent = Float(completedIntervals / timeInterval)
        
        if clockwise {
            guard percent < maximumValue else {
                DispatchQueue.main.async(execute: {
                    self.value = self.maximumValue
                    self.expire()
                })
                return
            }
        } else {
            percent = maximumValue - percent
            guard percent > minimumValue else {
                DispatchQueue.main.async(execute: {
                    self.value = self.minimumValue
                    self.expire()
                })
                return
            }
        }
        
        DispatchQueue.main.async {
            self.value = percent
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(refreshInterval * Float(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            self.updateProgress()
        }
    }
    
    private func expire() {
        referenceDate = nil
        if let completion = expiredCompletion {
            completion()
        }
    }
    
    /// Indefinitly delays the completion of the automatic refreshing when
    /// a `timeInterval` has been specified.
    public func pause() {
        referenceDate = nil
    }
    
    /// Resumes the automatic refreshing of the indicator after a `pause`
    /// has been initiated or `timeInterval` has been set.
    public func resume() {
        referenceDate = Date(timeIntervalSinceNow: -completedIntervals)
        updateProgress()
    }
    
    /// Begins a new automatic refresh cycle
    public func reset(timeInterval: TimeInterval, completion: ExpiredCompletion? = nil) {
        expiredCompletion = completion
        self.timeInterval = timeInterval
    }
}

#endif
