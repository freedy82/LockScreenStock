//
//  ContentView.swift
//  LockScreenStock
//

import SwiftUI
import WidgetKit

struct ContentView: View {
	@ObservedObject var stockList: StockList
	//let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	@State private var presentAlert = false
	@State private var stockSymbol: String = ""
	
    var body: some View {
		NavigationView {
			List {
				ForEach(stockList.stocks) { stock in
					StockCell(stock: stock)
				}
				.onMove(perform: moveStock)
				.onDelete(perform: deleteStock)
			}
			.navigationTitle("Stock List")
			.toolbar {
				EditButton()
				Button("Add") {
					presentAlert = true
				}
				.alert("Add Stock", isPresented: $presentAlert, actions: {
					TextField("Stock Symbol", text: $stockSymbol)
					Button("Add", action: {
						stockList.addStock(symbol: stockSymbol)
						//updateJSON()
						stockSymbol = ""
						WidgetCenter.shared.reloadAllTimelines()
					})
					Button("Cancel", role: .cancel, action: {
						stockSymbol = ""
					})
				})
			}
		}
		.onAppear() {
			self.stockList.updateStockPrice(completion: {stocks in})
		}
    }
			
	func moveStock(from: IndexSet, to: Int) {
		withAnimation {
			stockList.stocks.move(fromOffsets: from, toOffset: to)
		}
		stockList.saveConfig()
		WidgetCenter.shared.reloadAllTimelines()
	}
	
	func deleteStock(offset: IndexSet) {
		withAnimation {
			stockList.stocks.remove(atOffsets: offset)
		}
		stockList.saveConfig()
		WidgetCenter.shared.reloadAllTimelines()
	}

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(stockList: testStockList)
    }
}

