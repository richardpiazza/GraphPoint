import Foundation
import Swift2D

/// The point where the axes of the `CartesianPlane` intersect.
///
/// The origin divides each of these axes into two halves, a positive and a negative semi-axis. Points can then be
/// located with reference to the origin by giving their numerical coordinates—that is, the positions of their
/// projections along each axis, either in the positive or negative direction. The coordinates of the origin are always
/// all zero. For example: {0,0}.
public typealias CartesianOrigin = Point
