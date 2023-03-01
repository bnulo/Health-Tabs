//
//  ContentView.swift
//  HealthTabs
//
//  Created by bnulo on 3/1/23.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        TabView {
            ForEach(TabItem.allCases) { item in
                NavigationView {
                    TabItemView(item: item)
                }
                .tabItem {
                    Image(systemName: item.imageName)
                    Text(item.title)
                }
                .tag(item.id)
            }
        }
        .accentColor(Color.tabColor)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
