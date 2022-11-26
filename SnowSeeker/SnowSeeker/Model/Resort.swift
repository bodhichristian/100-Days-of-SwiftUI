//
//  Resort.swift
//  SnowSeeker
//
//  Created by christian on 11/25/22.
//

import Foundation

struct Resort: Codable, Identifiable {
    let id: String
    let name: String
    let country: String
    let description: String
    let imageCredit: String
    let price: Int
    let size: Int
    let snowDepth: Int
    let elevation: Int
    let runs: Int
    let facilities: [String]
    var facilityTypes: [Facility] {
        facilities.map(Facility.init)
    }
    
    static let example = (Bundle.main.decode("resorts.json") as [Resort])[0]
}
