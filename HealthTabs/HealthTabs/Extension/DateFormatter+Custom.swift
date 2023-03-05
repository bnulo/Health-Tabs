//
//  DateFormatter+Custom.swift
//  HealthTabs
//
//  Created by bnulo on 3/1/23.
//

import Foundation

extension DateFormatter {

    static let ddMMMyyyyDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMMddyyyy")
        return formatter
    }()
    static let ddMMDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        return formatter
    }()
    static let mmmYYYYDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter
    }()
}
