//
//  File.swift
//  
//
//  Created by Amine Bensalah on 04/03/2020.
//

import Foundation
import XCTest
@testable import Container

class SettingsTests: XCTestCase {

    func testDevelopmentCreation() {
        let environement = Environement.development
        XCTAssertEqual(environement.name, "development")
        XCTAssertFalse(environement.isRelease)
    }

    func testProductionCreation() {
        let environement = Environement.production
        XCTAssertEqual(environement.name, "production")
        // https://alexplescan.com/posts/2016/05/03/swift-a-nicer-way-to-tell-if-your-app-is-running-in-debug-mode/
        XCTAssertFalse(environement.isRelease)
    }

    func testTestableCreation() {
        let environement = Environement.testing
        XCTAssertEqual(environement.name, "testing")
        XCTAssertFalse(environement.isRelease)
    }

    func testOtherCreation() {
        let environement = Environement.custom(name: "local")
        XCTAssertEqual(environement.name, "local")
        XCTAssertFalse(environement.isRelease)
    }

    func testCustomEnvironementWithCustomArgument() {
        let environement = Environement(name: "custom", arguments: ["isTest"])
        XCTAssertEqual(environement.name, "custom")
        XCTAssertEqual(environement.arguments, ["isTest"])
    }

    func testProcessString() {
        Environement.process.DATABASE_TYPE = "postgres"
        XCTAssertEqual(Environement.process.DATABASE_TYPE, "postgres")
        Environement.process.DATABASE_TYPE = nil
        XCTAssertNil(Environement.process.DATABASE_TYPE)
    }

    func testProcessGeneric() {
        Environement.process.DATABASE_PORT = 5432
        XCTAssertEqual(Environement.process.DATABASE_PORT, 5432)
        Environement.process.DATABASE_PORT = nil
        XCTAssertNil(Environement.process.DATABASE_PORT)
    }

    func testGetEnvironementValue() {
        Environement.process.DATABASE_TYPE = "postgres"
        let type = Environement.get("DATABASE_TYPE")
        XCTAssertEqual(type, "postgres")
    }

    func testGetRawValueDevelopmentCreation() {
        let environement = Environement.development
        XCTAssertEqual(environement.rawValue, "development")
    }

    func testEquality() {
        let environement = Environement.development
        let custom = Environement.custom(name: "development")
        XCTAssertEqual(environement, custom)
    }

    func testCreateWithRawValue() {
        ["development","production","testing","custom"].forEach {
            XCTAssertEqual(Environement(rawValue: $0)?.name, $0)
        }
    }

    func testOptionsString() {
        let urlPath = "http://myurl.com"
        var environement = Environement.development
        environement.setStringOption(key: "URL", value: urlPath)
        XCTAssertEqual(environement.options.URL, urlPath)
        XCTAssertEqual(environement.getStringOption(key: "URL"), urlPath)

        environement.setStringOption(key: "URL", value: nil)
        XCTAssertNil(environement.options.URL)
        XCTAssertNil(environement.getStringOption(key: "URL"))
    }

    func testOptionGeneric() {
        let urlPort = 8080
        var environement = Environement.development
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
