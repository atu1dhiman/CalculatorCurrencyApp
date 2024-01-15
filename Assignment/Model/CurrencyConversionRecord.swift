//
//  CurrencyConversionRecord.swift
//  Assignment
//
//  Created by Atul Dhiman on 15/01/24.
//

import Foundation
struct CurrencyConversionRecord : Codable {
    var sourceCurrency: String
    var targetCurrency: String
    var exchangeRate: Double
    var amount: Double
    var date: Date
}
