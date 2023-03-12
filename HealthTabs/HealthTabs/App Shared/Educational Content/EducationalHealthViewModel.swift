//
//  EducationalHealthViewModel.swift
//  HealthTabs
//
//  Created by bnulo on 3/5/23.
//

import Foundation
import HealthKit

final class EducationalHealthViewModel: ObservableObject {

    @Published private(set) var dataValues: [HKStatistics] = []
    @Published private(set) var stepCountModels: [StepCountModel] = []

    private var store: HKHealthStore?
    private var query: HKStatisticsCollectionQuery?

    private let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
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
    }

    deinit {
        stopQuery()
    }

    // MARK: - Intent

    func onViewAppear() {
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
//        requestStepCount { [weak self] stepsCountModels in
//            DispatchQueue.main.async {
//                self?.stepCountModels = stepsCountModels
//            }
//        }
    }

    private func requestStepCount1(completion: @escaping ([StepCountModel]) -> Void) {

        // query
        let startDate = Calendar.current.date(byAdding: .day,
                                              value: -7,
                                              to: Date()) ?? Date()
        let endDate = Date()
        let anchoreDate = Date.firstDayOfWeek()
        let dailyComponent = DateComponents(day: 1)

        var healthStat = [StepCountModel]()
        let predicate = HKQuery.predicateForSamples(withStart: startDate,
                                                    end: endDate,
                                                    options: .strictStartDate)
        query = HKStatisticsCollectionQuery(quantityType: stepCountType,
                                            quantitySamplePredicate: predicate,
                                            options: .cumulativeSum,
                                            anchorDate: anchoreDate,
                                            intervalComponents: dailyComponent)
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

    private func stopQuery() {
        guard let query else { return }
        store?.stop(query)
    }

    private func createAuthorizationStatusDescription(for types: Set<HKObjectType>) -> String {
        guard let store else { return "" }
        var dictionary = [HKAuthorizationStatus: Int]()

        for type in types {
            let status = store.authorizationStatus(for: type)

            if let existingValue = dictionary[status] {
                dictionary[status] = existingValue + 1
            } else {
                dictionary[status] = 1
            }
        }

        var descriptionArray: [String] = []

        if let numberOfAuthorizedTypes = dictionary[.sharingAuthorized] {
            let format = NSLocalizedString("AUTHORIZED_NUMBER_OF_TYPES", comment: "")
            let formattedString = String(format: format, locale: .current, arguments: [numberOfAuthorizedTypes])

            descriptionArray.append(formattedString)
        }
        if let numberOfDeniedTypes = dictionary[.sharingDenied] {
            let format = NSLocalizedString("DENIED_NUMBER_OF_TYPES", comment: "")
            let formattedString = String(format: format, locale: .current, arguments: [numberOfDeniedTypes])

            descriptionArray.append(formattedString)
        }
        if let numberOfUndeterminedTypes = dictionary[.notDetermined] {
            let format = NSLocalizedString("UNDETERMINED_NUMBER_OF_TYPES", comment: "")
            let formattedString = String(format: format, locale: .current, arguments: [numberOfUndeterminedTypes])

            descriptionArray.append(formattedString)
        }

        // Format the sentence for grammar if there are multiple clauses.
        if let lastDescription = descriptionArray.last, descriptionArray.count > 1 {
            descriptionArray[descriptionArray.count - 1] = "and \(lastDescription)"
        }

        let description = "Sharing is " + descriptionArray.joined(separator: ", ") + "."

        return description
    }

    /// Write

    func createAndSaveSample() {
        let startDate = Calendar.current.date(bySettingHour: 14,
                                              minute: 35,
                                              second: 0,
                                              of: Date())!
        let endDate = Calendar.current.date(bySettingHour: 15,
                                              minute: 0,
                                              second: 0,
                                              of: Date())!
        let distanceQuantity = HKQuantity(unit: .meter(),
                                          doubleValue: 628.0)
        let sample = HKQuantitySample(type: distanceType,
                                      quantity: distanceQuantity,
                                      start: startDate,
                                      end: endDate)
        store?.save(sample) { success, error in
            if let error { log(error.localizedDescription) }
            // completion(success)
            log(success)
        }
    }

    /// Read

    func calculateDailyStepCountForPastWeek() {

        let anchor = Date.getDateOf7DaysAgoAt0AM()
        let daily = DateComponents(day: 1)

        let exactlySevenDaysAgo = Calendar.current.date(byAdding: .day,
                                                        value: -7,
                                                        to: Date()) ?? Date()
        let oneWeekAgo = HKQuery.predicateForSamples(withStart: exactlySevenDaysAgo,
                                                     end: nil,
                                                     options: .strictStartDate)
        self.query = HKStatisticsCollectionQuery(quantityType: stepCountType,
                                                 quantitySamplePredicate: oneWeekAgo,
                                                 anchorDate: anchor,
                                                 intervalComponents: daily)
        self.query?.initialResultsHandler = { [weak self] query, statisticsCollection, error in
            // after executing the query we get this
            // update ui with statisticsCollection
            if let statisticsCollection {
                self?.updateUIFromStatistics(statisticsCollection)
            }
            log(query)
            if let error { log(error.localizedDescription) }
        }

        // update handler
        self.query?.statisticsUpdateHandler = { [weak self] query, statistics,
            statisticsCollection, error in
            // this will be called whenever databse has new data
            if let statisticsCollection {
                self?.updateUIFromStatistics(statisticsCollection)
            }
            if let statistics { log(statistics) }
            log(query)
            if let error { log(error.localizedDescription) }
        }

        guard let query else { return }
        store?.execute(query)
    }

    func updateUIFromStatistics(_ statisticsCollection: HKStatisticsCollection) {
        DispatchQueue.main.async { [weak self] in
            self?.dataValues = []
            let startDate = Calendar.current.date(byAdding: .day,
                                                  value: -6,
                                                  to: Date())!
            let endDate = Date()

            statisticsCollection.enumerateStatistics(from: startDate,
                                                     to: endDate) { [weak self] statistics, _ in
                self?.dataValues.append(statistics)
            }
        }
    }

    func read() {
        // HKSampleQuery, HKStatisticsQuery, HKStatisticsCollectionQuery, ...
        let startDate = Calendar.current.date(byAdding: .day,
                                              value: -7,
                                              to: Date()) ?? Date()
        let endDate = Date()
//        let anchoreDate = Date.firstDayOfWeek()
//        let dailyComponent = DateComponents(day: 1)
        let predicate = HKQuery.predicateForSamples(withStart: startDate,
                                                    end: endDate,
                                                    options: .strictStartDate)

        // MARK: - HKStatisticsQuery
        // a query that performs statistics on samples, specifically quantity samples.

        // Aggregation Style of Samples (Type of Statistics):

        // 1- Cumulative
        // Ex total number of steps taken during a workout,
        // Ex total amount of calories burned
        // Ex total amount of caffeine consumed today

        // 2- Discrete
        // Ex average UV exposure of today
        // Ex Max body temprature from when some one was sick a couple of weeks ago
        // Average, Min, Max on Health Data

        // total amount of steps someone took this past week
        // HKStatistics Object:
            // Start Date
            // Ednd Date
            // Sum Quantity

        // if we were to sum up all of someone's steps over all of their devices
        // it may have duplications
        //

        // MARK: - HKStatisticsCollectionQuery

        // it is a query that performs stats on fixed time intervals that you specify. Ex daily cadance
        // anchor date: represents when our statistics starts being computed and
        // how our samples get bucketed
        // HKStatisticsCollection Object: is a collection of statistics
        // so for example for each day we get statistics with sum of our steps
            // Start Date
            // Ednd Date
            // Sum Quantity

        // MARK: - Receive ongoing updates
        // it can listens to the updates to the user's health data
        // Set update handler before executing the query. So our query will live in the background,
        // listening to any new statistics or new data coming into the health database.
        // so we have to stop when we are done with the data that we need.
            // Construct the query
            // Execute on the HealthStore
            // Update our UI with the results
            //
//        let query = HKStatisticsQuery(quantityType: distanceType,
//                          quantitySamplePredicate: predicate) { query, stats, error in
//
//        }
    }

    /// SampleQuery Workout

    func readWorkout() {

        let workoutType = HKObjectType.workoutType()

        // most recent date
        let sort = [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]

        let query = HKSampleQuery(sampleType: workoutType,
                                  predicate: nil,
                                  limit: 1,
                                  sortDescriptors: sort) { query, samples, error in
            log(query)
            if let error { log(error) }
            if let samples { log(samples) }
        }
        store?.execute(query)
    }
}
