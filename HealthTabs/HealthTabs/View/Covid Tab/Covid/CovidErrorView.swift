//
//  CovidErrorView.swift
//  HealthTabs
//
//  Created by bnulo on 3/1/23.
//

import SwiftUI

struct CovidErrorView: View {

    @ObservedObject var viewModel: CovidViewModel

    var body: some View {
        VStack {

            Text(viewModel.errorMessage ?? "")
                .padding(.bottom)
            Button {
                viewModel.fetch()
            } label: {
                Text("Try again!")
                    .foregroundColor(.blue)
            }
        }
    }
}

struct CovidErrorView_Previews: PreviewProvider {
    static var previews: some View {
        CovidErrorView(viewModel: CovidViewModel())
    }
}
