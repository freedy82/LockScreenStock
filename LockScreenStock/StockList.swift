//
//  StockList.swift
//  LockScreenStock
//

import Foundation
import Alamofire
import SwiftyJSON
//import SwiftYFinance


class StockList: ObservableObject {
	@Published var stocks : [Stock] = []
	//var appGroupName: String { "group." + Bundle.main.bundleIdentifier! }
	
	init(stocks: [Stock] = []) {
		if stocks.count > 0 {
			self.stocks = stocks
		} else {
			self.loadConfig()
		}
	}
	
	func saveConfig() {
		UserDefaults(suiteName: "group.com.freedy.LockScreenStock")!.set(getSymbolListString(), forKey: "stocks")
	}
	
	func loadConfig() {
		let symbolList = UserDefaults(suiteName: "group.com.freedy.LockScreenStock")!.string(forKey: "stocks")
		//print("load symbolList: \(symbolList)")
		var newStocks : [Stock] = []
		symbolList?.components(separatedBy: ",").forEach { symbol in
			newStocks.append(Stock(longName: "", regularMarketPrice: 0, regularMarketChangePercent: 0, symbol: symbol))
		}
		self.stocks = newStocks
	}

	func addStock(symbol:String) {
		self.stocks.append(Stock(longName: "", regularMarketPrice: 0, regularMarketChangePercent: 0, symbol: symbol))
		saveConfig()
		updateStockPrice(completion: {stocks in})
	}
	
	func getSymbolListString() -> String {
		var result = ""
		self.stocks.forEach { stock in
			if result != "" {
				result += ","
			}
			result += stock.symbol
		}
		return result
	}
	
	func updateStockPrice(completion: @escaping ([Stock]) -> () ) {
		let symbolListString = getSymbolListString()
		if symbolListString != "" {
			let encodeString = symbolListString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
			let urlString = "https://query1.finance.yahoo.com/v7/finance/quote?symbols=" + encodeString + "&lang=zh-Hant-HK&region=HK"
			
			AF.request(urlString).validate().responseData { response in
				switch response.result {
				case .success(let data):
					let jsonRaw = try! JSON(data: data)
					//print(jsonRaw["quoteResponse"]["result"])
					
					var newStocks : [Stock] = []
					
					jsonRaw["quoteResponse"]["result"].forEach{ idx, stockInfo in
						print(stockInfo)
						if stockInfo["typeDisp"] == "股票" || stockInfo["typeDisp"] == "指數" {
							newStocks.append(Stock(longName: stockInfo["longName"].rawValue as! String, regularMarketPrice: stockInfo["regularMarketPrice"].floatValue, regularMarketChangePercent: stockInfo["regularMarketChangePercent"].floatValue, symbol: stockInfo["symbol"].rawValue as! String) )
						}
					}
					
					self.stocks = newStocks
					completion(newStocks)
				case .failure(let error):
					// Handle as previously error
					print(error)
					break
				}
			}
		}
		//print(symbolListString)
	}
}

var stockList = StockList(stocks: [])
var testStockList = StockList(stocks: [testStock1,testStock2,testStock3])


