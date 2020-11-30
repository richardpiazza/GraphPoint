import Foundation

public enum GraphPointError: Swift.Error {
    case invalidPoint(_ point: CartesianPoint)
    case invalidDegree(_ degree: Degree)
    case invalidRadius(_ radius: Radius)
    case unhandledQuadrantTransition(_ q1: Quadrant, _ q2: Quadrant)
}
