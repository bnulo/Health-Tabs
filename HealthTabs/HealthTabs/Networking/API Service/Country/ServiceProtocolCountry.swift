//
//  ServiceProtocolCountry.swift
//  HealthTabs
//
//  Created by bnulo on 3/4/23.
//

import Foundation

protocol ServiceProtocolCountry {

    func fetchCountry(url: URL?,
                      completion: @escaping (Result<[CountryModel], APIError>) -> Void)
}
