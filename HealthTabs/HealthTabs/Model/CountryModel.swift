//
//  CountryModel.swift
//  HealthTabs
//
//  Created by bnulo on 3/2/23.
//

import Foundation
/*
 "name": {
       "common": "Iran",
       "official": "Islamic Republic of Iran",
       "nativeName": {
         "fas": {
           "official": "Ø¬Ù…Ù‡ÙˆØ±ÛŒ Ø§Ø³Ù„Ø§Ù…ÛŒ Ø§ÛŒØ±Ø§Ù†",
           "common": "Ø§ÛŒØ±Ø§Ù†"
         }
       }
     }
"flags": {
     "png": "https://flagcdn.com/w320/de.png",
     "svg": "https://flagcdn.com/de.svg",
     "alt": "The flag of Germany is composed of three equal horizontal bands of black, red and gold."
   }
*/
struct CountryModel: Codable {
    let name: NameModel?
    let flags: FlagModel?

    static func example1() -> [CountryModel] {
        [
            CountryModel(name: NameModel(common: "Algeria"),
                         flags: FlagModel(png: "https://flagcdn.com/w320/dz.png",
                                          svg: "https://flagcdn.com/dz.svg",
                                          alt: "The flag of Algeria ..."))
        ]
    }
}
struct NameModel: Codable {
    let common: String
}
struct FlagModel: Codable {
    let png: String?
    let svg: String?
    let alt: String?
}
