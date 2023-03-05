//
//  String+RFC3339.swift
//  HealthTabs
//
//  Created by bnulo on 3/1/23.
//

import Foundation

extension String {

    var rfc3339Date: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:SS.SSSZ" // 2022-11-21T12:00:00.000Z
        let date = dateFormatter.date(from: self)
        return date
    }
}
