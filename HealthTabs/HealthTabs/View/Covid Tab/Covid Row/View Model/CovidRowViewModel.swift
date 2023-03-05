//
//  CovidRowViewModel.swift
//  HealthTabs
//
//  Created by bnulo on 3/2/23.
//

import SwiftUI

class CovidRowViewModel: ObservableObject, Identifiable {

    let model: CovidModel
    let service: ServiceProtocolCountry

    var id: String {
        model.id
    }

    @Published private(set) var flagImageUrl: URL?
    @Published private(set) var flagImageAltString: String?
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var country: String = ""

    init(model: CovidModel, service: ServiceProtocolCountry = APIService()) {
        self.model = model
        self.country = model.country
        self.service = service
        fetchCountry(named: model.country)
    }

    // MARK: -

    func fetchCountry(named name: String) {

        isLoading = true
        errorMessage = nil

        // Ex. Flag-API URL https://restcountries.com/v3.1/name/deutschland

        // MARK: - we need to correct some of country names because of Flag-API bugs

        var countryNameWithoutSpace = name.replacingOccurrences(of: " ", with: "")
        countryNameWithoutSpace = countryNameWithoutSpace
            .replacingOccurrences(of: "CzechRepublic", with: "Czechia")
        let countryName = correctCountryName(countryNameWithoutSpace)

        // MARK: -

        let url = URL(string: "\(APIConstants.countryBaseUrl)/\(countryName)")
        log("country url: \(APIConstants.countryBaseUrl)/\(countryName)")
        service.fetchCountry(url: url) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {

                self.isLoading = false
                switch result {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    // log(error.description)
                    log("country url: \(APIConstants.countryBaseUrl)/\(countryName)")
                    log(error)
                case .success(let responseModel):
                    log("--- sucess with \(responseModel.count)")
                    let country = responseModel.first {
                        $0.name?.common.lowercased()
                            .replacingOccurrences(of: " ", with: "") == countryNameWithoutSpace
                            .lowercased()
                    }
                    if let country {
                        if let urlString = country.flags?.png {
                            self.flagImageUrl = URL(string: urlString)
                        }
                        self.flagImageAltString = country.flags?.alt
                        log(self.flagImageAltString ?? "alt str")
                    }
                }
            }
        }
    }

    // MARK: -

    private func correctCountryName(_ name: String) -> String {
        var countryName = name.replacingOccurrences(of: " ", with: "")
        countryName = countryName.replacingOccurrences(of: "UnitedStates", with: "states")
        countryName = countryName.replacingOccurrences(of: "UnitedKingdom", with: "uk")
        countryName = countryName.replacingOccurrences(of: "SouthKorea", with: "korea")
        countryName = countryName.replacingOccurrences(of: "SaudiArabia", with: "Saudi")

        return countryName
    }
}
