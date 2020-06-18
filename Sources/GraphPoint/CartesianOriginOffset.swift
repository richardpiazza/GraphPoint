import Foundation
import Swift2D

/// The x and y offset from a `CartesianOrigin` within a `CartesianPlane`
///
/// For example:
/// ```swift
/// let plane = CartesianPlane(size: Size(width: 100, height: 100))
/// let cartesianPoint = CartesianPoint(x: 10, y: 0)
/// // cartesianPoint == CartesianOriginOffset(x: 10, y: 0)
/// // A `CartesianPoint` is already translated
/// let cartesianFrame = CartesianFrame(x: 60, y: -50, width: 20, height: 20)
/// // cartesianFrame offset == CartesianOriginOffset(x: 10, y: 0)
/// ```
public typealias CartesianOriginOffset = Point
