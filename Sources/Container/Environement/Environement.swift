//
//  Environement.swift
//  DependencyInjection
//
//  Created by Amine Bensalah on 14/11/2019.
//

import Foundation

public struct Environment: Equatable, RawRepresentable {

    public typealias RawValue = String

    /// An environment for deploying your application to consumers.
    public static var production: Environment {
        return .init(name: "production")
    }

    /// An environment for developing your application.
    public static var development: Environment {
        return .init(name: "development")
    }

    /// An environment for testing your application.
    public static var testing: Environment {
        return .init(name: "testing")
    }

    /// Creates a custom environment.
    public static func custom(name: String) -> Environment {
        return .init(name: name)
    }

    /// Gets a key from the process environment
    public static func get(_ key: String) -> String? {
        return ProcessInfo.processInfo.environment[key]
    }

    /// See `Equatable`
    public static func == (lhs: Environment, rhs: Environment) -> Bool {
        return lhs.name == rhs.name && lhs.isRelease == rhs.isRelease
    }

    public static var process: Process {
        return Process()
    }

    /// The environment's unique name.
    public let name: String

    /// `true` if this environment is meant for production use cases.
    ///
    /// This usually means reducing logging, disabling debug information, and sometimes
    /// providing warnings about configuration states that are not suitable for production.
    public var isRelease: Bool {
        return !_isDebugAssertConfiguration()
    }

    /// The command-line arguments for this `Environment`.
    public var arguments: [String]

    public var rawValue: String {
        return name
    }

    public init?(rawValue: String) {
        switch rawValue {
        case "production":
            self = Environment.production
        case "development":
            self = Environment.development
        case "testing":
            self = Environment.testing
        default:
            // return nil
            self = Environment(name: rawValue)
        }
    }

    // MARK: Init
    /// Create a new `Environment`.
    public init(name: String, arguments: [String] = CommandLine.arguments) {
        self.name = name
        self.arguments = arguments
    }
}

extension Environment {

    @dynamicMemberLookup
    public struct Process {

        private let _info: ProcessInfo

        internal init(info: ProcessInfo = .processInfo) {
            self._info = info
        }

        /// Gets a variable's value from the process' environment, and converts it to generic type `T`.
        ///
        ///     Environment.process.DATABASE_PORT = 3306
        ///     Environment.process.DATABASE_PORT // 3306
        public subscript<T>(dynamicMember member: String) -> T? where T: LosslessStringConvertible {
            get {
                guard let raw = self._info.environment[member], let value = T(raw) else { return nil }
                return value
            }
            nonmutating set (value) {
                if let raw = value?.description {
                    setenv(member, raw, 1)
                } else {
                    unsetenv(member)
                }
            }
        }

        /// Gets a variable's value from the process' environment as a `String`.
        ///
        ///     Environment.process.DATABASE_USER = "root"
        ///     Environment.process.DATABASE_USER // "root"
        public subscript(dynamicMember member: String) -> String? {
            get {
                guard let value = self._info.environment[member] else { return nil }
                return value
            }
            nonmutating set(value) {
                if let raw = value {
                    setenv(member, raw, 1)
                } else {
                    unsetenv(member)
                }
            }
        }
    }
}

extension Environment {

    @dynamicMemberLookup
    public struct InfoPlist {

        private var _info: [String: Any]

        internal init(infoPlist: [String: Any]) {
            self._info = infoPlist
        }

        /// Gets a variable's value from the process' environment, and converts it to generic type `T`.
        ///
        ///     Environment.process.DATABASE_PORT = 3306
        ///     Environment.process.DATABASE_PORT // 3306
        public subscript<T>(dynamicMember member: String) -> T? where T: LosslessStringConvertible {
            get {
                guard let raw = self._info[member], let value = raw as? T else { return nil }
                return value
            }
            mutating set (value) {
                self._info[member] = value as Any
            }
        }

        /// Gets a variable's value from the process' environment as a `String`.
        ///
        ///     Environment.process.DATABASE_USER = "root"
        ///     Environment.process.DATABASE_USER // "root"
        public subscript(dynamicMember member: String) -> String? {
            get {
                guard let raw = self._info[member], let value = raw as? String else { return nil }
                return value
            }
            mutating set(value) {
                self._info[member] = value as Any
            }
        }
    }
}
