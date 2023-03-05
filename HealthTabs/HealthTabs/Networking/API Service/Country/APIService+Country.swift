//
//  APIService+Country.swift
//  HealthTabs
//
//  Created by bnulo on 3/4/23.
//

import Foundation

extension APIService: ServiceProtocolCountry {

    func fetchCountry(url: URL?,
                      completion: @escaping (Result<[CountryModel], APIError>) -> Void) {
        fetch([CountryModel].self, url: url, completion: completion)
    }
}
