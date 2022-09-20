//
//  LockScreenStockApp.swift
//  LockScreenStock
//

import SwiftUI
import Foundation

@main
struct LockScreenStockApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(stockList: stockList)
        }
    }
}

