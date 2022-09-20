//
//  Stock.swift
//  LockScreenStock
//

import Foundation

struct Stock : Identifiable {
	var id = UUID()
	var longName: String
	var regularMarketPrice: Float32
	var regularMarketChangePercent: Float32
	var symbol: String
}


var testStock0 = Stock(longName: "", regularMarketPrice: 0.00, regularMarketChangePercent: 0.0, symbol: "")

var testStock1 = Stock(longName: "China Mobile", regularMarketPrice: 51.35, regularMarketChangePercent: -0.15, symbol: "0941.HK")
var testStock2 = Stock(longName: "SINO", regularMarketPrice: 11.42, regularMarketChangePercent: 0.01, symbol: "0083.HK")
var testStock3 = Stock(longName: "MTR", regularMarketPrice: 39.95, regularMarketChangePercent: 0.0, symbol: "0066.HK")

