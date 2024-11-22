//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateWeather(_ coinManager : CoinManager,coin: CoinModel)
    func didFailWithError(error : Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "8FBBF28D-CB8D-4831-9F0D-1D9965A2F5F8"
    var delegate : CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    
    func getCoinPrice(for currency : String){
        
        let urlString = "\(baseURL)/\(currency.uppercased())?apikey=\(apiKey)"
        performRequest(urlString: urlString)
        
    }
    
    func performRequest(urlString : String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    print(error!)
                    return
                }
                
                if let safeData = data{
                    if let coin = self.parseJSON(coinData: safeData){
                        self.delegate?.didUpdateWeather(self, coin: coin)
                    }
                    
                }
                
                
            }
            task.resume()
        }
        
    }
    
    func parseJSON(coinData : Data)->CoinModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let currencyQuote = decodedData.asset_id_quote
            let currencyRate = decodedData.rate
            let currencyBase = decodedData.asset_id_base
            print(currencyQuote)
            print(currencyRate)
            let coinModel = CoinModel(assestBase: currencyBase, assetQuote: currencyQuote, rate: currencyRate)
            return coinModel
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }

    
}
