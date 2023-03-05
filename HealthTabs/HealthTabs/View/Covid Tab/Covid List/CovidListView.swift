//
//  CovidListView.swift
//  HealthTabs
//
//  Created by bnulo on 3/1/23.
//

import SwiftUI

struct CovidListView: View {

    @ObservedObject var viewModel: CovidViewModel

    var body: some View {

            ZStack {
                TabItem.covid.color
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                List {
                    ForEach(viewModel.rowViewModels) { viewModel in
                        NavigationLink {
                            CovidDetailView(viewModel: CovidDetailViewModel(model: viewModel.model))
                        } label: {
                            CovidRowView(viewModel: viewModel)
                        }

                    }
                    .listRowBackground(TabItem.covid.color)
                }
                .listStyle(PlainListStyle())
            }
            .navigationBarTitle("Covid Stats", displayMode: .inline)
    }
}

struct CovidListView_Previews: PreviewProvider {
    static var previews: some View {
        CovidListView(viewModel: CovidViewModel())
    }
}
