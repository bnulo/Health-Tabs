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

    private var store: HKHealthStore?
    private var query: HKStatisticsCollectionQuery?

    private let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount)!

    private var shareTypes: Set<HKSampleType> {
        Set([stepCountType])
    }
    private var readTypes: Set<HKSampleType> {
        Set([stepCountType])
    }

    // MARK: -

    init() {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        store = HKHealthStore()

        // TODO: - Check/Get Permissions more user-friendly
        requestAuthorization { [weak self] success in
            if success {
                self?.setStats()
            }
        }
    }

    // MARK: - User Permisson

    func requestAuthorization(completion: @escaping (Bool) -> Void) {

        guard HKHealthStore.isHealthDataAvailable() else { return }
        // toShare is writing access
        // read is reading access
        store?.requestAuthorization(toShare: shareTypes,
                                    read: readTypes) { success, error in
            if let error {
                log(error)
            }
            completion(success) // success does not mean authorized
        }
    }

    // MARK: - Stats

    private func setStats() {

        requestStepCount { [weak self] stepsCountModels in
            DispatchQueue.main.async {
                self?.stepCountModels = stepsCountModels
            }
        }
    }

    private func requestStepCount(completion: @escaping ([StepCountModel]) -> Void) {

        // query
        let startDate = Date.getDateOfFirstDayOfSomeYearsAgo(numberOfYears: 5)
        let endDate = Date()
        guard let startDate else { return }

        let monthInterval = DateComponents(month: 1)

        var healthStat = [StepCountModel]()
        let predicate = HKQuery.predicateForSamples(withStart: startDate,
                                                    end: endDate,
                                                    options: .strictStartDate)

        query = HKStatisticsCollectionQuery(quantityType: stepCountType,
                                            quantitySamplePredicate: predicate,
                                            options: .cumulativeSum,
                                            anchorDate: startDate,
                                            intervalComponents: monthInterval)

        query?.initialResultsHandler = { query, statistics, error in
            log(query)
            if let error {
                log(error)
                return
            }
            statistics?.enumerateStatistics(from: startDate,
                                            to: endDate,
                                            with: { stats, _ in
                let stat = StepCountModel(stat: stats.sumQuantity(),
                                      date: stats.startDate)
                healthStat.append(stat)
            })

            completion(healthStat)
        }

        guard let query = query else { return }
        store?.execute(query)
    }

    // MARK: - Helper

    private func setMaxValue() {
        let values = stepCountModels.map({
                                    value(from: $0.stat).value })
        DispatchQueue.main.async { [weak self] in
            self?.maxStatValue = values.max() ?? 0
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
