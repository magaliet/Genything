import Foundation

// MARK: Build

public extension Gen {

    /// Alias pairing a weighted probability to a generator
    typealias WeightedGenerator<T> = (weight: Int, generator: Gen<T>)

    /// Returns: A generator which produces values from the provided generators according to their weights
    ///
    /// The probability of choosing a weighted generator is equal to the generator's weight divided by the total weight
    ///
    /// - Parameter weights: Pairing of generators with their weights
    ///
    /// - Returns: The generator
    static func weighted(_ weights: [WeightedGenerator<T>]) -> Gen<T> {
        assert(weights.allSatisfy { $0.weight > 0 }, "`Gen.weighted(weights:)` called with impossible weights. Ratios must be one or greater.")

        let total = weights.map { $0.weight }.reduce(0, +)
        return Gen<Int>.from(0..<total).flatMap { roll in
            var currWeight = 0
            return weights.first { (weight, _) in
                currWeight += weight
                return roll < currWeight
            }!.generator
        }
    }

    /// Returns: A generator which produces values from the provided constant values according to their weights
    ///
    /// The probability of choosing a weighted value is equal to the value's weight divided by the total weight
    ///
    /// - SeeAlso: `weighted(weights:)`
    ///
    /// - Parameter weights: Pairing of generators with their weights
    ///
    /// - Returns: The generator
    static func weighted(_ weights: [(Int, T)]) -> Gen<T> {
        weighted(
            weights.map { (weight, value) in
                (weight, Gen.constant(value))
            }
        )
    }
}