//
//  CovidListView.swift
//  HealthTabs
//
//  Created by bnulo on 3/1/23.
//

import SwiftUI

struct CovidListView: View {

    @ObservedObject var viewModel: CovidViewModel
    let backgroundColor: Color

    var body: some View {

            ZStack {
                backgroundColor
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                List {
                    ForEach(viewModel.rowViewModels) { viewModel in
                        NavigationLink {
                            CovidDetailView(viewModel: CovidDetailViewModel(model: viewModel.model),
                            backgroundColor: backgroundColor)
                        } label: {
                            CovidRowView(viewModel: viewModel)
                        }

                    }
                    .listRowBackground(backgroundColor)
                }
                .listStyle(PlainListStyle())
            }
            .navigationBarTitle("Covid Stats", displayMode: .inline)
    }
}

struct CovidListView_Previews: PreviewProvider {
    static var previews: some View {
        CovidListView(viewModel: CovidViewModel(), backgroundColor: TabItem.covid.color)
    }
}
