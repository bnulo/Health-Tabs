//
//  HealthRowView.swift
//  HealthTabs
//
//  Created by bnulo on 3/5/23.
//

import SwiftUI

struct HealthRowView: View {

    let stat: StepCountModel
    let geo: GeometryProxy
    let maxStatValue: Int
    let statValue: (value: Int, desc: String)

    var date: String {
        DateFormatter.mmmYYYYDateFormatter.string(from: stat.date)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: ViewConstants.rowSpacing) {

            HStack {
                Text(date)
                    .opacity(ViewConstants.dateOpacity)
                Spacer()
                Text("\(statValue.value) count")
//                Text(statValue.desc)
            }
            RoundedRectangle(cornerRadius: ViewConstants.barRadius)
                .fill(Color.tabColor)
                .frame(width: getFrameWidth(geo: geo,
                                            max: maxStatValue,
                                            value: statValue.value),
                       height: ViewConstants.barHeight)
        }
        .padding(.top, ViewConstants.rowTopPadding)
        .listRowBackground(Color.healthColor)
    }

    // MARK: - Helper

    private func getFrameWidth(geo: GeometryProxy, max: Int, value: Int) -> CGFloat {
        max == 0 ? CGFloat(0) : CGFloat(value)/CGFloat(max)*geo.size.height*0.6
    }

    // MARK: - Constants

    struct ViewConstants {
        static let rowTopPadding: CGFloat = 10
        static let barHeight: CGFloat = 8
        static let barRadius: CGFloat = barHeight/2
        static let rowSpacing: CGFloat = 2
        static let dateOpacity: CGFloat = 0.5
    }
}
