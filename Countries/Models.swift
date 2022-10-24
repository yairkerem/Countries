//
//  Models.swift
//  Countries
//
//  Created by Yair Kerem on 21/06/2022.
//

import Foundation

struct Country {
    let name: String
    let population: Int
    let imageName: String
    var continent: Continent
    var isVisited: Bool
}
enum Continent: String {
    case america = "America"
    case europe = "Europe"
    case asia = "Asia"
    case oceania = "Oceania"
    case africa = "Africa"
    case antarctica = "Antarctica"
}
