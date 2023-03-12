//
//  HealthViewModel.swift
//  HealthTabs
//
//  Created by bnulo on 3/2/23.
//

import Foundation
import HealthKit
import SwiftUI

final class HealthViewModel: ObservableObject {

    @Published private(set) var maxStatValue: Int = 0
    @Published private(set) var totalStatValue: Int = 0
    @Published private(set) var dataValues: [HKStatistics] = []
    @Published private(set) var stepCountModels: [StepCountModel] = [] {
        didSet {
            setMaxValue()
            setTotalValue()
        }
    }

    private let quantityTypeIdentifier: HKQuantityTypeIdentifier = .stepCount
    private let store = HealthData.healthStore

    private var shareTypes: Set<HKSampleType> {

        guard let stepCountType = HKQuantityType
            .quantityType(forIdentifier: .stepCount) else {
            return Set([])
        }
        return Set([stepCountType])
    }

    private var readTypes: Set<HKSampleType> {

        guard let stepCountType = HKQuantityType
            .quantityType(forIdentifier: .stepCount) else {
            return Set([])
        }
        return Set([stepCountType])
    }

    // MARK: - User Permisson

    func requestAuthorization(completion: @escaping (Bool) -> Void) {

        guard HKHealthStore.isHealthDataAvailable() else { return }
        // toShare is writing access
        // read is reading access

        // TODO: - Check/Get Permissions more user-friendly
        HealthData.requestHealthDataAccessIfNeeded(toShare: shareTypes,
                                                   read: readTypes) { success in
            completion(success) // success does not mean authorized
        }
    }

    // MARK: -

    func onViewAppear() {

        requestAuthorization { [weak self] success in
            if success {
                self?.setStats()
            }
        }
    }

    // MARK: - Stats

    private func setStats() {

        HealthData.fetchStepCountStatistics(with: quantityTypeIdentifier) { [weak self] stepsCountModels in
            DispatchQueue.main.async {
                self?.stepCountModels = stepsCountModels
            }
        }
    }

    // MARK: - Helper

    private func setMaxValue() {
        let values = stepCountModels.map({
                                    value(from: $0.stat).value })
        let max = values.max() ?? 0
        DispatchQueue.main.async { [weak self] in
            self?.maxStatValue = max
        }
    }

    private func setTotalValue() {
        let total = stepCountModels.reduce(0) {
            $0 + value(from: $1.stat).value
        }
        DispatchQueue.main.async { [weak self] in
            self?.totalStatValue = total
        }
    }

    func value(from stat: HKQuantity?) -> (value: Int, desc: String) {

        guard let stat = stat else { return (0, "") }
        let measurementFormatter = MeasurementFormatter()
        measurementFormatter.unitStyle = .long

        if stat.is(compatibleWith: .count()) {
            let value = stat.doubleValue(for: .count())
            return (Int(value), stat.description)
        }
        return (0, "")
    }
}
