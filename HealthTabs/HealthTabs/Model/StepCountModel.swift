//
//  StepCountModel.swift
//  HealthTabs
//
//  Created by bnulo on 3/2/23.
//

import Foundation
import HealthKit

struct StepCountModel: Identifiable {
    let id = UUID()
    let stat: HKQuantity?
    let date: Date
}
