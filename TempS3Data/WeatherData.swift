//
//  WeatherData.swift
//  TempS3Data
//
//  Created by Oleksandr Seminov on 2/9/25.
//


struct WeatherEntry: Codable {
    let temperature: Double
    let humidity: Double
    let date: String
    let time: String
}

typealias WeatherData = WeatherEntry
