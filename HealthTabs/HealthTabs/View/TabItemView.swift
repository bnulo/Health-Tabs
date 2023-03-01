//
//  TabItemView.swift
//  HealthTabs
//
//  Created by bnulo on 3/1/23.
//

import SwiftUI

struct TabItemView: View {

    let item: TabItem

    var body: some View {

        ZStack {
            item.color
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            switch item {
            case .covid:
                CovidView()
            case .health:
                HealthView()
            }
        }
    }
}

struct TabItemView_Previews: PreviewProvider {
    static var previews: some View {
        TabItemView(item: .health)
    }
}
