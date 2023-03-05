//
//  APIService+Covid.swift
//  HealthTabs
//
//  Created by bnulo on 3/1/23.
//

import Foundation

extension APIService: ServiceProtocolCovid {

    func fetchCovidStats(url: URL?,
                         completion: @escaping (Result<[CovidModel], APIError>) -> Void) {
        fetch([CovidModel].self, url: url, completion: completion)
    }
}
