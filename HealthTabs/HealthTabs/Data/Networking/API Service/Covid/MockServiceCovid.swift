//
//  MockServiceCovid.swift
//  HealthTabs
//
//  Created by bnulo on 3/4/23.
//

import Foundation

struct MockServiceCovid: ServiceProtocolCovid {

    var covidResult: Result<[CovidModel], APIError>

    func fetchCovidStats(url: URL?,
                         completion: @escaping(Result<[CovidModel], APIError>) -> Void) {

        completion(covidResult)
    }
}
