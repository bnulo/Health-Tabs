//
//  CovidDetailViewModel.swift
//  HealthTabs
//
//  Created by bnulo on 3/2/23.
//

import SwiftUI

class CovidDetailViewModel: ObservableObject {

    private let model: CovidModel

    @Published private(set) var country: String = ""
    @Published private(set) var infected: String?
    @Published private(set) var tested: String?
    @Published private(set) var recovered: String?
    @Published private(set) var deceased: String?

    @Published private(set) var moreDataUrl: URL?
    @Published private(set) var historyDataUrl: URL?
    @Published private(set) var sourceUrl: URL?
    @Published private(set) var lastUpdatedApify: String?

    @Published private(set) var imageUrl: URL?

    init(model: CovidModel) {
        self.model = model
        self.country = model.country

        if let infected = model.infected, let integer = infected.value as? Int {
            self.infected = "Infected: \(integer)"
        }
//
        if let tested = model.tested, let integer = tested.value as? Int {
            self.tested = "Tested: \(integer)"
        }

        if let recovered = model.recovered, let integer = recovered.value as? Int {
            self.recovered = "Recovered: \(integer)"
        }

        if let deceased = model.deceased, let integer = deceased.value as? Int {
            self.deceased = "Deceased: \(integer)"
        }

        if let moreData = model.moreData {
            self.moreDataUrl = URL(string: moreData)
        }

        if let historyData = model.historyData {
            self.historyDataUrl = URL(string: historyData)
        }

        if let sourceUrl = model.sourceUrl {
            self.sourceUrl = URL(string: sourceUrl)
        }

        if let lastUpdatedApify = model.lastUpdatedApify {
            if let date = lastUpdatedApify.rfc3339Date {

                let text = DateFormatter.ddMMMyyyyDateFormatter.string(from: date)
                if !text.isEmpty {
                    self.lastUpdatedApify = "Last Updated: \(text)"
                }
            }
        }
    }
}
