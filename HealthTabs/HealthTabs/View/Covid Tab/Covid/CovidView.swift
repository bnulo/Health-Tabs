//
//  CovidView.swift
//  HealthTabs
//
//  Created by bnulo on 3/1/23.
//

import SwiftUI
import Kingfisher

struct CovidView: View {

    @ObservedObject var viewModel: CovidViewModel

    var body: some View {
        ZStack {
            if viewModel.isLoading {
                LoadingView()
            } else if viewModel.errorMessage != nil {
                CovidErrorView(viewModel: viewModel)
            } else {
                CovidListView(viewModel: viewModel)
            }
        }
        .onAppear {
            configKingCacheSize()
        }
    }

    // MARK: - Helper

    private func configKingCacheSize() {
        // Configure Kingfisher's Cache
        let cache = ImageCache.default

        // Constrain Memory Cache to 10 MB
        cache.memoryStorage.config.totalCostLimit = 1024 * 1024 * 10

        // Constrain Disk Cache to 100 MB
        cache.diskStorage.config.sizeLimit = 1024 * 1024 * 100
    }
}

struct CovidView_Previews: PreviewProvider {
    static var previews: some View {
        CovidView(viewModel: CovidViewModel())
    }
}
