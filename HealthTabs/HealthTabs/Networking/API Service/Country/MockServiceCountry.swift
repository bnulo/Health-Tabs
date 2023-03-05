//
//  MockServiceCountry.swift
//  HealthTabs
//
//  Created by bnulo on 3/4/23.
//

import Foundation

struct MockServiceCountry: ServiceProtocolCountry {

    var countryResult: Result<[CountryModel], APIError>

    func fetchCountry(url: URL?,
                      completion: @escaping (Result<[CountryModel], APIError>) -> Void) {
        completion(countryResult)
    }
}
