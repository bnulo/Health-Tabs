//
//  HealthTabsTests.swift
//  HealthTabsTests
//
//  Created by bnulo on 3/1/23.
//

import XCTest
@testable import HealthTabs
import Combine

final class HealthTabsTests: XCTestCase {

    var subscriptions = Set<AnyCancellable>()

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    override func tearDown() {
        subscriptions = []
    }

    // MARK: - Covid Service

    // MARK: - Success

    func test_fetchCovidStats_success() {

        let result = Result<[CovidModel], APIError>
            .success(CovidModel.items)
        let viewModel = CovidViewModel(service: MockServiceCovid(covidResult: result))
        let promise = expectation(description: "getting items")
        viewModel.$models.sink { models in
            if models.count > 0 {
                promise.fulfill()
            }
        }.store(in: &subscriptions)

        wait(for: [promise], timeout: 2)
    }

    // MARK: - Failure

    func test_fetchCovidStats_failure() {

        let result = Result<[CovidModel], APIError>
            .failure(APIError.badURL)

        let viewModel = CovidViewModel(service: MockServiceCovid(covidResult: result))

        let promise = expectation(description: "show error message")
        viewModel.$models.sink { models in
            if !models.isEmpty {
                XCTFail("models list has to be empty on service failure")
            }
        }.store(in: &subscriptions)

        viewModel.$errorMessage.sink { message in
            if message != nil {
                promise.fulfill()
            }
        }.store(in: &subscriptions)

        wait(for: [promise], timeout: 2)
    }

    // MARK: - Country Service

    // MARK: - Success

    func test_fetchCountry_success() {

        // Covid Country and Flag Country has to be same
        // in this test we use first country "Algeria"
        let result = Result<[CountryModel], APIError>
            .success(CountryModel.example1())
        let viewModel = CovidRowViewModel(model: CovidModel.example1(),
        service: MockServiceCountry(countryResult: result))
        let promise = expectation(description: "getting flag url")
        viewModel.$flagImageUrl.sink { url in
            if url != nil {
                promise.fulfill()
            }
        }.store(in: &subscriptions)

        wait(for: [promise], timeout: 2)
    }

    // MARK: - Failure

    func test_fetchCountry_failure() {

        let result = Result<[CountryModel], APIError>
            .failure(APIError.badURL)

        let viewModel = CovidRowViewModel(model: CovidModel.example1(),
        service: MockServiceCountry(countryResult: result))

        let promise = expectation(description: "show error message")
        viewModel.$flagImageUrl.sink { url in
            if url != nil {
                XCTFail("flag image url has to be nil on service failure")
            }
        }.store(in: &subscriptions)

        viewModel.$errorMessage.sink { message in
            if message != nil {
                promise.fulfill()
            }
        }.store(in: &subscriptions)

        wait(for: [promise], timeout: 2)
    }

}
