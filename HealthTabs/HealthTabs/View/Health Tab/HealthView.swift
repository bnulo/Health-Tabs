//
//  HealthView.swift
//  HealthTabs
//
//  Created by bnulo on 3/1/23.
//

import SwiftUI

struct HealthView: View {

    @ObservedObject var viewModel: HealthViewModel
    let backgroundColor: Color

    var body: some View {
        ZStack {
            backgroundColor
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()

            GeometryReader { geo in
                VStack {

                    totalMaxStatsHeaderView

                    List(viewModel.stepCountModels) { stat in

                        HealthRowView(stat: stat,
                                      geo: geo,
                                      maxStatValue: viewModel.maxStatValue,
                                      statValue: viewModel.value(from: stat.stat))
                    }.listStyle(PlainListStyle())
                }
            }

        }
        .navigationBarTitle("Step Count", displayMode: .inline)
    }

    // MARK: - Header View

    private var totalMaxStatsHeaderView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Total")
                Text("\(viewModel.totalStatValue) count")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            VStack(alignment: .leading) {
                Text("Max")
                Text("\(viewModel.maxStatValue) count")
            }
        }
        .padding()
    }
}

struct HealthView_Previews: PreviewProvider {
    static var previews: some View {
        HealthView(viewModel: HealthViewModel(), backgroundColor: TabItem.health.color)
    }
}
