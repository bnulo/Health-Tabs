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

        let desc = "Testing Service Success case. " +
        "We have to get the same mock data received by service"
        let promise = expectation(description: desc)

        viewModel.$models.sink { models in
            if models.count > 0 {
                if models == CovidModel.items {
                    promise.fulfill()
                }
            }
        }.store(in: &subscriptions)

        wait(for: [promise], timeout: 2)
    }

    // MARK: - Failure Case caused by badURL

    func test_fetchCovidStats_failure() {

        let result = Result<[CovidModel], APIError>
            .failure(APIError.badURL)

        let viewModel = CovidViewModel(service: MockServiceCovid(covidResult: result))

        let promise = expectation(description: "show appropriate error message for badURL")
        viewModel.$models.sink { models in
            if !models.isEmpty {
                XCTFail("models list has to be empty on service failure")
            }
        }.store(in: &subscriptions)

        viewModel.$errorMessage.sink { message in
            if message == APIError.badURL.localizedDescription {
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
        let data = CountryModel.example1()
        guard let urlString = data.first?.flags?.png else { return }
        guard let imageUrl = URL(string: urlString) else { return }

        let result = Result<[CountryModel], APIError>
            .success(data)
        let viewModel = CovidRowViewModel(model: CovidModel.example1(),
        service: MockServiceCountry(countryResult: result))

        let desc = "Testing Service Success case. " +
        "We have to get the same mock png url for flag image received by service"
        let promise = expectation(description: desc)
        viewModel.$flagImageUrl.sink { url in

            if url == imageUrl {
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

        let promise = expectation(description: "show appropriate error message for badURL")
        viewModel.$flagImageUrl.sink { url in
            if url != nil {
                XCTFail("flag image url has to be nil on service failure")
            }
        }.store(in: &subscriptions)

        viewModel.$errorMessage.sink { message in
            if message == APIError.badURL.localizedDescription {
                promise.fulfill()
            }
        }.store(in: &subscriptions)

        wait(for: [promise], timeout: 2)
    }

}
