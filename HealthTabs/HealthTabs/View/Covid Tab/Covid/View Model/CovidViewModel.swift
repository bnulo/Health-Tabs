//
//  CovidViewModel.swift
//  HealthTabs
//
//  Created by bnulo on 3/1/23.
//

import SwiftUI

class CovidViewModel: ObservableObject {

    @Published private(set) var models: [CovidModel] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?

    var rowViewModels: [CovidRowViewModel] {
        models.map { CovidRowViewModel(model: $0) }
    }

    let service: ServiceProtocolCovid

    init(service: ServiceProtocolCovid = APIService()) {
        self.service = service
        fetch()
    }

    func fetch() {

        isLoading = true
        errorMessage = nil

        let url = URL(string: APIConstants.covidUrl)
        service.fetchCovidStats(url: url) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {

                self.isLoading = false
                switch result {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    // log(error.description)
                    log(error)
                case .success(let responseModel):
                    log("--- sucess with \(responseModel.count)")
                    self.models = responseModel
                }
            }
        }

    }

    // MARK: - preview helpers

    static func errorState() -> CovidViewModel {
        let viewModel = CovidViewModel()
        viewModel.errorMessage = APIError.url(URLError.init(.notConnectedToInternet)).localizedDescription
        return viewModel
    }

    static func successState() -> CovidViewModel {
        let viewModel = CovidViewModel()
        viewModel.models = [CovidModel.example1(),
                           CovidModel.example2(),
                           CovidModel.example3()]

        return viewModel
    }

}
