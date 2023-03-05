//
//  CovidModel.swift
//  HealthTabs
//
//  Created by bnulo on 3/1/23.
//

import Foundation

struct UncertainValue<T: Decodable, U: Decodable>: Decodable {
    public var tValue: T?
    public var uValue: U?

    public var value: Any? {
        return tValue ?? uValue
    }

    public init(tValue: T? = nil, uValue: U? = nil) {
        self.tValue = tValue
        self.uValue = uValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        tValue = try? container.decode(T.self)
        uValue = try? container.decode(U.self)
        if tValue == nil && uValue == nil {
            // Type mismatch
            throw DecodingError
                .typeMismatch(type(of: self),
                              DecodingError
                    .Context(codingPath: [],
                    debugDescription: "The value is not of type \(T.self) and not even \(U.self)"))
        }

    }
}

/*
 "infected": 271023,
     "tested": "NA",
     "recovered": 182526,
     "deceased": 6881,
     "country": "Algeria",
     "moreData": "https://api.apify.com/v2/key-value-stores/pp4Wo2slUJ78ZnaAi/records/LATEST?disableRedirect=true",
     "historyData": "https://api.apify.com/v2/datasets/hi0DJXpcyzDwtg2Fm/items?format=json&clean=1",
     "sourceUrl": "https://www.worldometers.info/coronavirus/",
     "lastUpdatedApify": "2022-11-21T12:00:00.000Z"
 */

struct CovidModel: Decodable, Identifiable {

    let infected: UncertainValue<Int, String>?
    let tested: UncertainValue<Int, String>?
    let recovered: UncertainValue<Int, String>?
    let deceased: UncertainValue<Int, String>?
    let country: String
    let moreData: String?
    let historyData: String?
    let sourceUrl: String?
    let lastUpdatedApify: String?

    var id: String { country }

    static let items = [example1(), example2(), example3()]

    static func example1() -> CovidModel {
        return CovidModel(
            infected: UncertainValue(tValue: 271023),
            tested: nil,
            recovered: UncertainValue(tValue: 182526),
            deceased: UncertainValue(tValue: 6881),
            country: "Algeria",
            moreData:
"https://api.apify.com/v2/key-value-stores/pp4Wo2slUJ78ZnaAi/records/LATEST?disableRedirect=true",
            historyData:
"https://api.apify.com/v2/datasets/hi0DJXpcyzDwtg2Fm/items?format=json&clean=1",
            sourceUrl: "https://www.worldometers.info/coronavirus/",
            lastUpdatedApify: "2022-11-21T12:00:00.000Z"
        )

    }

    static func example2() -> CovidModel {
        return CovidModel(
            infected: UncertainValue(),
            tested: nil,
            recovered: nil,
            deceased: nil,
            country: "Austria",
            moreData:
"https://api.apify.com/v2/key-value-stores/RJtyHLXtCepb4aYxB/records/LATEST?disableRedirect=true",
            historyData:
                "https://api.apify.com/v2/datasets/EFWZ2Q5JAtC6QDSwV/items?format=json&clean=1",
            sourceUrl: nil,
            lastUpdatedApify: "2022-11-21T12:03:00.000Z"
        )

    }

    static func example3() -> CovidModel {
        return CovidModel(
            infected: UncertainValue(tValue: 823954),
            tested: UncertainValue(tValue: 7356956),
            recovered: UncertainValue(tValue: 813750),
            deceased: UncertainValue(tValue: 9972),
            country: "Azerbaijan",
            moreData:
"https://api.apify.com/v2/key-value-stores/ThmCW2NVnrLa0tVp5/records/LATEST?disableRedirect=true",
            historyData:
"https://api.apify.com/v2/datasets/JtJHjnBtnIeKYpFi0/items?format=json&clean=1",
            sourceUrl:
                "https://koronavirusinfo.az/az/page/statistika/azerbaycanda-cari-veziyyet",
            lastUpdatedApify: "2022-11-21T12:00:35.000Z"
        )
    }
}
