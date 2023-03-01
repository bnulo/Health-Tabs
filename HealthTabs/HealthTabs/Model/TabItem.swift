//
//  TabItem.swift
//  HealthTabs
//
//  Created by bnulo on 3/1/23.
//

import SwiftUI

enum TabItem: Int, Identifiable, CaseIterable {

    case covid = 1, health = 2

    var id: Int { return self.rawValue }

    var title: String {
        switch self {
        case .covid:
            return "Covid"
        case .health:
            return "Health"
        }
    }

    var imageName: String {
        switch self {
        case .covid:
            return Constants.ImageName.statistics
        case .health:
            return Constants.ImageName.heart
        }
    }

    var color: Color {
        switch self {
        case .covid:
            return Color.covidColor
        case .health:
            return Color.healthColor
        }
    }
}
