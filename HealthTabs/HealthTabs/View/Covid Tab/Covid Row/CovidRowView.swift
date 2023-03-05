//
//  CovidRowView.swift
//  HealthTabs
//
//  Created by bnulo on 3/1/23.
//

import SwiftUI
import Kingfisher

struct CovidRowView: View {

    @ObservedObject var viewModel: CovidRowViewModel

    var body: some View {
        HStack {
            flagImage
            countryNameTitle
        }
    }

    // MARK: - Child View

    private var flagImage: some View {
        KFImage(viewModel.flagImageUrl)
            .placeholder({
                ProgressView()
            })
            .loadDiskFileSynchronously()
            .cacheMemoryOnly(false)
            .fade(duration: 0.25)
            .resizable()
            .scaledToFit()
            .frame(width: Constants.Size.flagImageWidth,
                   height: Constants.Size.flagImageWidth)
    }

    private var countryNameTitle: some View {
        Text(viewModel.country)
            .font(.title2)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct CovidRowView_Previews: PreviewProvider {
    static var previews: some View {
        CovidRowView(viewModel: CovidRowViewModel(model: CovidModel.example3()))
    }
}
