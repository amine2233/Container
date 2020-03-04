import XCTest
@testable import Container

class ContainerTests: XCTestCase {

    func testContainerCreation() {
        let config = Config()
        var services = Services()

        services.register(MockDataBaseProtocol.self) { container in
            return MockDataBase(name: "postgres")
        }

        let container = Container(environment: .testing,
                                  config: config,
                                  services: services)

        do {
            let database = try container.make(MockDataBaseProtocol.self)
            XCTAssertEqual(database.name, "postgres")
        } catch {
            XCTFail(error.localizedDescription)
        }

        container.shutdown()
    }

    func testContainerPreference() {
        var environement = Environment.testing
        environement.setStringOption(key: "DB_NAME", value: "sqlite")

        var config = Config()
        var services = Services()

        config.prefer(MockDataBaseLocal.self, for: MockDataBaseProtocol.self)

        services.register(MockDataBase.self) { container in
            return MockDataBase(name: "postgres")
        }

        services.register(MockDataBaseLocal.self) { container in
            return MockDataBaseLocal(name: container.environment.options.DB_NAME ?? "")
        }

        let container = Container(environment: environement,
                                  config: config,
                                  services: services)

        do {
            let database = try container.make(MockDataBaseLocal.self)
            XCTAssertEqual(database.name, "sqlite")
        } catch {
            XCTFail(error.localizedDescription)
        }

        container.shutdown()
    }
}
