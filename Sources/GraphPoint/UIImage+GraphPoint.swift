#if (os(iOS) || os(tvOS))

import UIKit

public extension UIImage {
    static func filledImage(withPath path: CGMutablePath, color: UIColor, context: CGContext?) -> UIImage? {
        guard let context = context else {
            return nil
        }
        
        var image: UIImage? = nil
        
        context.setLineWidth(0)
        context.setFillColor(color.cgColor)
        context.addPath(path)
        context.fillPath()
        
        image = UIGraphicsGetImageFromCurrentImageContext()
        
        return image
    }
    
    static func strokedImage(withPath path: CGMutablePath, color: UIColor, strokeWidth: CGFloat, context: CGContext?) -> UIImage? {
        guard let context = context else {
            return nil
        }
        
        var image: UIImage? = nil
        
        context.setLineWidth(strokeWidth)
        context.setStrokeColor(color.cgColor)
        context.addPath(path)
        context.strokePath()
        
        image = UIGraphicsGetImageFromCurrentImageContext()
        
        return image
    }
}

#endif
