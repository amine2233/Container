//
//  File.swift
//  
//
//  Created by Amine Bensalah on 04/03/2020.
//

import Foundation
import XCTest
@testable import Container

class EnvironementTests: XCTestCase {

    func testDevelopmentCreation() {
        let environement = Environment.development
        XCTAssertEqual(environement.name, "development")
        XCTAssertFalse(environement.isRelease)
    }

    func testProductionCreation() {
        let environement = Environment.production
        XCTAssertEqual(environement.name, "production")
        // https://alexplescan.com/posts/2016/05/03/swift-a-nicer-way-to-tell-if-your-app-is-running-in-debug-mode/
        XCTAssertFalse(environement.isRelease)
    }

    func testTestableCreation() {
        let environement = Environment.testing
        XCTAssertEqual(environement.name, "testing")
        XCTAssertFalse(environement.isRelease)
    }

    func testOtherCreation() {
        let environement = Environment.custom(name: "local")
        XCTAssertEqual(environement.name, "local")
        XCTAssertFalse(environement.isRelease)
    }

    func testCustomEnvironementWithCustomArgument() {
        let environement = Environment(name: "custom", arguments: ["isTest"])
        XCTAssertEqual(environement.name, "custom")
        XCTAssertEqual(environement.arguments, ["isTest"])
    }

    func testProcessString() {
        Environment.process.DATABASE_TYPE = "postgres"
        XCTAssertEqual(Environment.process.DATABASE_TYPE, "postgres")
        Environment.process.DATABASE_TYPE = nil
        XCTAssertNil(Environment.process.DATABASE_TYPE)
    }

    func testProcessGeneric() {
        Environment.process.DATABASE_PORT = 5432
        XCTAssertEqual(Environment.process.DATABASE_PORT, 5432)
        Environment.process.DATABASE_PORT = nil
        XCTAssertNil(Environment.process.DATABASE_PORT)
    }

    func testGetEnvironementValue() {
        Environment.process.DATABASE_TYPE = "postgres"
        let type = Environment.get("DATABASE_TYPE")
        XCTAssertEqual(type, "postgres")
    }

    func testGetRawValueDevelopmentCreation() {
        let environement = Environment.development
        XCTAssertEqual(environement.rawValue, "development")
    }

    func testEquality() {
        let environement = Environment.development
        let custom = Environment.custom(name: "development")
        XCTAssertEqual(environement, custom)
    }

    func testCreateWithRawValue() {
        ["development","production","testing","custom"].forEach {
            XCTAssertEqual(Environment(rawValue: $0)?.name, $0)
        }
    }

    func testOptionsString() {
        let urlPath = "http://myurl.com"
        var environement = Environment.development
        environement.setStringOption(key: "URL", value: urlPath)
        XCTAssertEqual(environement.options.URL, urlPath)
        XCTAssertEqual(environement.getStringOption(key: "URL"), urlPath)

        environement.setStringOption(key: "URL", value: nil)
        XCTAssertNil(environement.options.URL)
        XCTAssertNil(environement.getStringOption(key: "URL"))
    }

    func testOptionGeneric() {
        let urlPort = 8080
        var environement = Environment.development
        environement.setOption(key: "URL_PORT", value: urlPort)
        XCTAssertEqual(environement.options.URL_PORT, urlPort)
        // XCTAssertEqual(environement.getOption(key: "URL_PORT"), urlPort)

        environement.setStringOption(key: "URL_PORT", value: nil)
        XCTAssertNil(environement.options.URL_PORT)
        XCTAssertNil(environement.getStringOption(key: "URL_PORT"))
    }

    static var allTests = [
        ("testDevelopmentCreation", testDevelopmentCreation),
        ("testProductionCreation", testProductionCreation),
        ("testTestableCreation", testTestableCreation),
        ("testOtherCreation", testOtherCreation),
        ("testCustomEnvironementWithCustomArgument", testCustomEnvironementWithCustomArgument),
        ("testProcessString", testProcessString),
        ("testProcessGeneric", testProcessGeneric),
        ("testGetEnvironementValue", testGetEnvironementValue),
        ("testGetRawValueDevelopmentCreation", testGetRawValueDevelopmentCreation),
        ("testEquality", testEquality),
        ("testCreateWithRawValue", testCreateWithRawValue),
        ("testOptionsString", testOptionsString),
        ("testOptionGeneric", testOptionGeneric),
    ]
}
