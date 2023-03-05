//
//  CovidDetailView.swift
//  HealthTabs
//
//  Created by bnulo on 3/1/23.
//

import SwiftUI

struct CovidDetailView: View {

    @ObservedObject var viewModel: CovidDetailViewModel

    var body: some View {
        ZStack {
            TabItem.covid.color
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 12) {
                    countryNameTitle
                    numbersGroup
                    linksGroup
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Child Views

    private var countryNameTitle: some View {
        Text(viewModel.country)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.title.bold())
            .padding(.vertical)
    }

    // MARK: - Numbers

    private var numbersGroup: some View {
        Group {

            if let date = viewModel.lastUpdatedApify {
                Text(date)
            }
            if let infected = viewModel.infected {
                Text(infected)
            }
            if let tested = viewModel.tested {
                Text(tested)
            }
            if let recovered = viewModel.recovered {
                Text(recovered)
            }
            if let deceased = viewModel.deceased {
                Text(deceased)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Links

    private var linksGroup: some View {

        Group {
            if let moreData = viewModel.moreDataUrl {
                Link(destination: moreData) {
                    Text("More Data")
                }
            }
            if let historyData = viewModel.historyDataUrl {
                Link(destination: historyData) {
                    Text("History Data")
                }
            }
            if let sourceUrl = viewModel.sourceUrl {
                Link(destination: sourceUrl) {
                    Text("Source")
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct CovidDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CovidDetailView(viewModel: CovidDetailViewModel(model: CovidModel.example3()))
    }
}
