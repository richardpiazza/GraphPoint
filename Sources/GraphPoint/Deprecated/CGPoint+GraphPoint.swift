#if canImport(CoreGraphics)
import CoreGraphics

/// The center (0, 0) of a graph axis. Typically the center of a CGRect
@available(*, deprecated, renamed: "CartesianOrigin")
public typealias GraphOrigin = CGPoint

/// The X,Y offset of any `GraphFrame` to the `GraphOrigin`
///
/// *For example:*
///
/// * In **CGRect(0, 0, 100, 100)**, using **GraphFrame(60, -50, 20, 20)**,
/// the GraphOriginOffset is (10, 0)
@available(*, deprecated, renamed: "CartesianPoint")
public typealias GraphOriginOffset = CGPoint

#endif
