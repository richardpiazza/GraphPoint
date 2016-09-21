//===----------------------------------------------------------------------===//
//
// UIImage.swift
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

public extension UIImage {
    public static func filledImage(withPath path: CGMutablePath, color: UIColor, context: CGContext?) -> UIImage? {
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
    
    public static func strokedImage(withPath path: CGMutablePath, color: UIColor, strokeWidth: CGFloat, context: CGContext?) -> UIImage? {
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
