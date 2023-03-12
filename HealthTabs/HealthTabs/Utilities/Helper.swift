//
//  Helper.swift
//  HealthTabs
//
//  Created by bnulo on 3/5/23.
//

import Foundation

struct FeatureFlags {

    static let debug = false
}

func log(_ text: Any) {
    if FeatureFlags.debug {
        print(text)
    }
}
