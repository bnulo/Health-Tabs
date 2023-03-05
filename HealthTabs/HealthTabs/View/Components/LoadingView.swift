//
//  LoadingView.swift
//  HealthTabs
//
//  Created by bnulo on 3/1/23.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .padding(.bottom, 4)
            Text("Loading ...")
                .foregroundColor(.gray)
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
