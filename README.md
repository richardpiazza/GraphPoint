# GraphPoint
[![Version](https://img.shields.io/cocoapods/v/GraphPoint.svg?style=flat)](http://cocoadocs.org/docsets/GraphPoint)
[![Platform](https://img.shields.io/cocoapods/p/GraphPoint.svg?style=flat)](http://cocoadocs.org/docsets/GraphPoint)

GraphPoint is a library of Swift extensions for using a [Cartesian Coordinate System](https://en.wikipedia.org/wiki/Cartesian_coordinate_system) with CGRect.
The Cartesian Coordinate System defines the origin as the center point and
it uses several mathematical laws to determine angles and points within a CGRect.

For Example:

- Given a CGRect(0, 0, 100, 100)
- The origin would be CGPoint(50, 50)
- A CGPoint(75, 75) would be translated to GraphPoint(25, -25)
