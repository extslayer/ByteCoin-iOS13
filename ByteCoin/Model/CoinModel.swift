//
//  CoinModel.swift
//  ByteCoin
//
//  Created by Manmohan Shrivastava on 20/11/24.
//  Copyright © 2024 The App Brewery. All rights reserved.
//

import Foundation

struct CoinModel: Codable {
    let assestBase: String
    let assetQuote: String
    let rate: Double
}
