//
//  ServiceProtocolCovid.swift
//  HealthTabs
//
//  Created by bnulo on 3/1/23.
//

import Foundation

protocol ServiceProtocolCovid {

    func fetchCovidStats(url: URL?,
                         completion: @escaping(Result<[CovidModel], APIError>) -> Void)
}
