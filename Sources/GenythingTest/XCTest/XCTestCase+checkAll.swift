import Foundation
import Genything
import XCTest

// MARK: - Failure Detection / Context storage

/// In order to provide information about the Context we store a static map against `XCTestCase`
/// e.g. the `originalSeed` used for the test run
///
/// - Warning: Great care must be used to clear the context store after a test run
///
private extension XCTestCase {
    static var _contextStore = [String : Context]()

    var address: String {
        String(format: "%p", unsafeBitCast(self, to: Int.self))
    }

    var contextStore: Context? {
        get {
            XCTestCase._contextStore[address]
        }
        set(newValue) {
            XCTestCase._contextStore[address] = newValue
        }
    }

    func setupCheck(_ context: Context) {
        continueAfterFailure = false

        contextStore = context

        addTeardownBlock {
            defer {
                self.contextStore = nil
            }

            if
                let originalSeed = self.contextStore?.originalSeed,
                let failureCount = self.testRun?.failureCount,
                failureCount > 0
            {
                print("[Genything] - Check failed with seed `\(originalSeed)`.")
            }
        }
    }
}

// MARK: - Test

public extension XCTestCase {
    /// Iterates (lazily) over the provided generators, passing values to the `body` block for testing
    ///
    /// Will run a maximum of n times, where n is the provided `iterations` or the `Context` value
    ///
    /// - Attention: Sets `continueAfterFailure` to `false` for this `XCTestCase`
    ///
    /// - Parameters:
    ///   - context: The context to be used for generation
    ///   - gen1: A generator who's values will be used for testing
    ///   - body: A closure body where you may make your XCTest assertions
    ///
    /// - Attention: A failing predicate will assert with `XCTFail`
    ///
    func checkAll<T>(_ gen1: Gen<T>,
                     context: Context = .default,
                     file: StaticString = #filePath,
                     line: UInt = #line,
                     _ body: (T) throws -> Void) {
        setupCheck(context)

        do {
            try gen1
                .safe
                .forEach(context: context, body)
        } catch {
            fail(error, context: context, file: file, line: line)
        }
    }

    /// Iterates (lazily) over the provided generators, passing values to the `body` block for testing
    ///
    /// Will run a maximum of n times, where n is the provided `iterations` or the `Context` value
    ///
    /// - Attention: Sets `continueAfterFailure` to `false` for this `XCTestCase`
    ///
    /// - Parameters:
    ///   - context: The context to be used for generation
    ///   - gen1: A generator who's values will be used for testing
    ///   - gen2: A generator who's values will be used for testing
    ///   - body: A closure body where you may make your XCTest assertions
    ///
    /// - Attention: A failing predicate will assert with `XCTFail`
    ///
    func checkAll<T1, T2>(_ gen1: Gen<T1>,
                          _ gen2: Gen<T2>,
                          context: Context = .default,
                          file: StaticString = #filePath,
                          line: UInt = #line,
                          _ body: (T1, T2) throws -> Void) {
        checkAll(
            Gen.zip(gen1, gen2),
            context: context,
            file: file,
            line: line,
            body
        )
    }

    /// Iterates (lazily) over the provided generators, passing values to the `body` block for testing
    ///
    /// Will run a maximum of n times, where n is the provided `iterations` or the `Context` value
    ///
    /// - Attention: Sets `continueAfterFailure` to `false` for this `XCTestCase`
    ///
    /// - Parameters:
    ///   - context: The context to be used for generation
    ///   - gen1: A generator who's values will be used for testing
    ///   - gen2: A generator who's values will be used for testing
    ///   - gen3: A generator who's values will be used for testing
    ///   - body: A closure body where you may make your XCTest assertions
    ///
    /// - Attention: A failing predicate will assert with `XCTFail`
    ///
    func checkAll<T1, T2, T3>(_ gen1: Gen<T1>,
                              _ gen2: Gen<T2>,
                              _ gen3: Gen<T3>,
                              context: Context = .default,
                              file: StaticString = #filePath,
                              line: UInt = #line,
                              _ body: (T1, T2, T3) throws -> Void) rethrows {
        checkAll(
            Gen.zip(gen1, gen2, gen3),
            context: context,
            file: file,
            line: line,
            body
        )
    }

    /// Iterates (lazily) over the provided generators, passing values to the `body` block for testing
    ///
    /// Will run a maximum of n times, where n is the provided `iterations` or the `Context` value
    ///
    /// - Attention: Sets `continueAfterFailure` to `false` for this `XCTestCase`
    ///
    /// - Parameters:
    ///   - context: The context to be used for generation
    ///   - gen1: A generator who's values will be used for testing
    ///   - gen2: A generator who's values will be used for testing
    ///   - gen3: A generator who's values will be used for testing
    ///   - gen4: A generator who's values will be used for testing
    ///   - body: A closure body where you may make your XCTest assertions
    ///
    /// - Attention: A failing predicate will assert with `XCTFail`
    ///
    func checkAll<T1, T2, T3, T4>(_ gen1: Gen<T1>,
                                  _ gen2: Gen<T2>,
                                  _ gen3: Gen<T3>,
                                  _ gen4: Gen<T4>,
                                  context: Context = .default,
                                  file: StaticString = #filePath,
                                  line: UInt = #line,
                                  _ body: (T1, T2, T3, T4) throws -> Void) rethrows {
        checkAll(
            Gen.zip(gen1, gen2, gen3, gen4),
            context: context,
            file: file,
            line: line,
            body
        )
    }

    /// Iterates (lazily) over the provided generators, passing values to the `body` block for testing
    ///
    /// Will run a maximum of n times, where n is the provided `iterations` or the `Context` value
    ///
    /// - Attention: Sets `continueAfterFailure` to `false` for this `XCTestCase`
    ///
    /// - Parameters:
    ///   - context: The context to be used for generation
    ///   - gen1: A generator who's values will be used for testing
    ///   - gen2: A generator who's values will be used for testing
    ///   - gen3: A generator who's values will be used for testing
    ///   - gen4: A generator who's values will be used for testing
    ///   - gen5: A generator who's values will be used for testing
    ///   - body: A closure body where you may make your XCTest assertions
    ///
    /// - Attention: A failing predicate will assert with `XCTFail`
    ///
    func checkAll<T1, T2, T3, T4, T5>(
        _ gen1: Gen<T1>,
        _ gen2: Gen<T2>,
        _ gen3: Gen<T3>,
        _ gen4: Gen<T4>,
        _ gen5: Gen<T5>,
        context: Context = .default,
        file: StaticString = #filePath,
        line: UInt = #line,
        _ body: (T1, T2, T3, T4, T5) throws -> Void
    ) rethrows {
        checkAll(
            Gen.zip(gen1, gen2, gen3, gen4, gen5),
            context: context,
            file: file,
            line: line,
            body
        )
    }

    /// Iterates (lazily) over the provided generators, passing values to the `body` block for testing
    ///
    /// Will run a maximum of n times, where n is the provided `iterations` or the `Context` value
    ///
    /// - Note: This is a very complex check. Consider combining your generators first.
    ///
    /// - Attention: Sets `continueAfterFailure` to `false` for this `XCTestCase`
    ///
    /// - Parameters:
    ///   - context: The context to be used for generation
    ///   - gen1: A generator who's values will be used for testing
    ///   - gen2: A generator who's values will be used for testing
    ///   - gen3: A generator who's values will be used for testing
    ///   - gen4: A generator who's values will be used for testing
    ///   - gen5: A generator who's values will be used for testing
    ///   - gen6: A generator who's values will be used for testing
    ///   - body: A closure body where you may make your XCTest assertions
    ///
    /// - Attention: A failing predicate will assert with `XCTFail`
    ///
    func checkAll<T1, T2, T3, T4, T5, T6>(
        _ gen1: Gen<T1>,
        _ gen2: Gen<T2>,
        _ gen3: Gen<T3>,
        _ gen4: Gen<T4>,
        _ gen5: Gen<T5>,
        _ gen6: Gen<T6>,
        context: Context = .default,
        file: StaticString = #filePath,
        line: UInt = #line,
        _ body: (T1, T2, T3, T4, T5, T6) throws -> Void
    ) rethrows {
        checkAll(
            Gen.zip(gen1, gen2, gen3, gen4, gen5, gen6),
            context: context,
            file: file,
            line: line,
            body
        )
    }


    /// Iterates (lazily) over the provided generators, passing values to the `body` block for testing
    ///
    /// Will run a maximum of n times, where n is the provided `iterations` or the `Context` value
    ///
    /// - Note: This is a very complex check. Consider combining your generators first.
    ///
    /// - Attention: Sets `continueAfterFailure` to `false` for this `XCTestCase`
    ///
    /// - Parameters:
    ///   - context: The context to be used for generation
    ///   - gen1: A generator who's values will be used for testing
    ///   - gen2: A generator who's values will be used for testing
    ///   - gen3: A generator who's values will be used for testing
    ///   - gen4: A generator who's values will be used for testing
    ///   - gen5: A generator who's values will be used for testing
    ///   - gen6: A generator who's values will be used for testing
    ///   - gen7: A generator who's values will be used for testing
    ///   - body: A closure body where you may make your XCTest assertions
    ///
    /// - Attention: A failing predicate will assert with `XCTFail`
    ///
    func checkAll<T1, T2, T3, T4, T5, T6, T7>(
        _ gen1: Gen<T1>,
        _ gen2: Gen<T2>,
        _ gen3: Gen<T3>,
        _ gen4: Gen<T4>,
        _ gen5: Gen<T5>,
        _ gen6: Gen<T6>,
        _ gen7: Gen<T7>,
        context: Context = .default,
        file: StaticString = #filePath,
        line: UInt = #line,
        _ body: (T1, T2, T3, T4, T5, T6, T7) throws -> Void
    ) rethrows {
        checkAll(
            Gen.zip(gen1, gen2, gen3, gen4, gen5, gen6, gen7),
            context: context,
            file: file,
            line: line,
            body
        )
    }

    /// Iterates (lazily) over the provided generators, passing values to the `body` block for testing
    ///
    /// Will run a maximum of n times, where n is the provided `iterations` or the `Context` value
    ///
    /// - Note: This is a very complex check. Consider combining your generators first.
    ///
    /// - Attention: Sets `continueAfterFailure` to `false` for this `XCTestCase`
    ///
    /// - Parameters:
    ///   - context: The context to be used for generation
    ///   - gen1: A generator who's values will be used for testing
    ///   - gen2: A generator who's values will be used for testing
    ///   - gen3: A generator who's values will be used for testing
    ///   - gen4: A generator who's values will be used for testing
    ///   - gen5: A generator who's values will be used for testing
    ///   - gen6: A generator who's values will be used for testing
    ///   - gen7: A generator who's values will be used for testing
    ///   - gen8: A generator who's values will be used for testing
    ///   - body: A closure body where you may make your XCTest assertions
    ///
    /// - Attention: A failing predicate will assert with `XCTFail`
    ///
    func checkAll<T1, T2, T3, T4, T5, T6, T7, T8>(
        _ gen1: Gen<T1>,
        _ gen2: Gen<T2>,
        _ gen3: Gen<T3>,
        _ gen4: Gen<T4>,
        _ gen5: Gen<T5>,
        _ gen6: Gen<T6>,
        _ gen7: Gen<T7>,
        _ gen8: Gen<T8>,
        context: Context = .default,
        file: StaticString = #filePath,
        line: UInt = #line,
        _ body: (T1, T2, T3, T4, T5, T6, T7, T8) throws -> Void
    ) rethrows {
        checkAll(
            Gen.zip(gen1, gen2, gen3, gen4, gen5, gen6, gen7, gen8),
            context: context,
            file: file,
            line: line,
            body
        )
    }

    /// Iterates (lazily) over the provided generators, passing values to the `body` block for testing
    ///
    /// Will run a maximum of n times, where n is the provided `iterations` or the `Context` value
    ///
    /// - Note: This is a very complex check. Consider combining your generators first.
    ///
    /// - Attention: Sets `continueAfterFailure` to `false` for this `XCTestCase`
    ///
    /// - Parameters:
    ///   - context: The context to be used for generation
    ///   - gen1: A generator who's values will be used for testing
    ///   - gen2: A generator who's values will be used for testing
    ///   - gen3: A generator who's values will be used for testing
    ///   - gen4: A generator who's values will be used for testing
    ///   - gen5: A generator who's values will be used for testing
    ///   - gen6: A generator who's values will be used for testing
    ///   - gen7: A generator who's values will be used for testing
    ///   - gen8: A generator who's values will be used for testing
    ///   - gen9: A generator who's values will be used for testing
    ///   - body: A closure body where you may make your XCTest assertions
    ///
    /// - Attention: A failing predicate will assert with `XCTFail`
    ///
    func checkAll<T1, T2, T3, T4, T5, T6, T7, T8, T9>(
        _ gen1: Gen<T1>,
        _ gen2: Gen<T2>,
        _ gen3: Gen<T3>,
        _ gen4: Gen<T4>,
        _ gen5: Gen<T5>,
        _ gen6: Gen<T6>,
        _ gen7: Gen<T7>,
        _ gen8: Gen<T8>,
        _ gen9: Gen<T9>,
        context: Context = .default,
        file: StaticString = #filePath,
        line: UInt = #line,
        _ body: (T1, T2, T3, T4, T5, T6, T7, T8, T9) throws -> Void
    ) rethrows {
        checkAll(
            Gen.zip(gen1, gen2, gen3, gen4, gen5, gen6, gen7, gen8, gen9),
            context: context,
            file: file,
            line: line,
            body
        )
    }

    /// Iterates (lazily) over the provided generators, passing values to the `body` block for testing
    ///
    /// Will run a maximum of n times, where n is the provided `iterations` or the `Context` value
    ///
    /// - Note: This is a very complex check. Consider combining your generators first.
    ///
    /// - Attention: Sets `continueAfterFailure` to `false` for this `XCTestCase`
    ///
    /// - Parameters:
    ///   - context: The context to be used for generation
    ///   - gen1: A generator who's values will be used for testing
    ///   - gen2: A generator who's values will be used for testing
    ///   - gen3: A generator who's values will be used for testing
    ///   - gen4: A generator who's values will be used for testing
    ///   - gen5: A generator who's values will be used for testing
    ///   - gen6: A generator who's values will be used for testing
    ///   - gen7: A generator who's values will be used for testing
    ///   - gen8: A generator who's values will be used for testing
    ///   - gen9: A generator who's values will be used for testing
    ///   - gen10: A generator who's values will be used for testing
    ///   - body: A closure body where you may make your XCTest assertions
    ///
    /// - Attention: A failing predicate will assert with `XCTFail`
    ///
    func checkAll<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>(
        _ gen1: Gen<T1>,
        _ gen2: Gen<T2>,
        _ gen3: Gen<T3>,
        _ gen4: Gen<T4>,
        _ gen5: Gen<T5>,
        _ gen6: Gen<T6>,
        _ gen7: Gen<T7>,
        _ gen8: Gen<T8>,
        _ gen9: Gen<T9>,
        _ gen10: Gen<T10>,
        context: Context = .default,
        file: StaticString = #filePath,
        line: UInt = #line,
        _ body: (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10) throws -> Void
    ) rethrows {
        checkAll(
            Gen.zip(gen1, gen2, gen3, gen4, gen5, gen6, gen7, gen8, gen9, gen10),
            context: context,
            file: file,
            line: line,
            body
        )
    }
}