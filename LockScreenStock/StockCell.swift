//
//  StockCell.swift
//  LockScreenStock
//
//  Created by Freedy on 20/9/2022.
//

import Foundation
import SwiftUI
import WidgetKit

struct StockCell: View {
	var stock: Stock
	var body: some View {
		VStack(alignment: .leading) {
			HStack {
				if stock.regularMarketChangePercent >= 0 {
					Image(systemName: "arrowtriangle.up.fill")
				} else {
					Image(systemName: "arrowtriangle.down.fill")
					
				}
				Text(stock.symbol)
				Spacer()
				Text(String(format: "%.2f", stock.regularMarketPrice))
			}
			.font(.title2)
			.fontWeight(.bold)
			Text(stock.longName)
		}
	}
}

struct WidgetStockCell: View {
	var stock: Stock
	var widgetFamily: WidgetFamily
	var body: some View {
		HStack {
			if stock.regularMarketChangePercent >= 0 {
				Image(systemName: "arrowtriangle.up.fill")
			} else {
				Image(systemName: "arrowtriangle.down.fill")
				
			}
			if widgetFamily != .accessoryInline {
				Text(stock.longName).lineLimit(1)
				Spacer()
				Text(String(format: "%.2f", stock.regularMarketPrice))
			} else {
				Text(String(format: "%@ %.2f", stock.longName, stock.regularMarketPrice))
			}
		}
		.font(.body)
		//.fontWeight(.light)
	}
}
