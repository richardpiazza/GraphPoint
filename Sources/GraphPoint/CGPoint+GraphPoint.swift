#if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS))

import CoreGraphics

/// The center (0, 0) of a graph axis. Typically the center of a CGRect
public typealias GraphOrigin = CGPoint

/// The X,Y offset of any `GraphFrame` to the `GraphOrigin`
///
/// ***For example:***
///
/// In CGRect(0, 0, 100, 100) & GraphFrame(60, -50, 20, 20)
/// the GraphOriginOffset is (10, 0)
public typealias GraphOriginOffset = CGPoint

#endif
