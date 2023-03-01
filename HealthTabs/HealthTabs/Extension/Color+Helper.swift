//
//  Color+Helper.swift
//  HealthTabs
//
//  Created by bnulo on 3/1/23.
//

import SwiftUI

extension Color {
    static let covidColor = Color(UIColor.covidColor)
    static let healthColor = Color(UIColor.healthColor)
    static let tabColor = Color(UIColor.tabColor)
}

extension UIColor {
    static let covidColor = UIColor(named: "covidColor") ??
    UIColor.purple
    static let healthColor = UIColor(named: "healthColor") ??
    UIColor.blue
    static let tabColor = UIColor(named: "tabColor") ??
    UIColor.green
}
