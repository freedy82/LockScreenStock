//
//  widget.swift
//  widget
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
	@ObservedObject var stockList = StockList()
	
    func placeholder(in context: Context) -> SimpleEntry {
		return SimpleEntry(date: Date(), configuration: ConfigurationIntent(), stocks: [])
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
		stockList.loadConfig()
		stockList.updateStockPrice(completion: { stocks in
			let entry = SimpleEntry(date: Date(), configuration: configuration, stocks: stocks)
			completion(entry)
		})
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
		stockList.loadConfig()
		stockList.updateStockPrice(completion: { stocks in
			var entries: [SimpleEntry] = []
			
			let currentDate = Date()
			let entry = SimpleEntry(date: currentDate, configuration: configuration, stocks: stocks)
			entries.append(entry)
			
			let timeline = Timeline(entries: entries, policy: .atEnd)
			completion(timeline)
		})
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
	let stocks: [Stock]
}

struct widget1EntryView : View {
	@Environment(\.widgetFamily) var widgetFamily
    var entry: Provider.Entry
    var body: some View {
		switch(widgetFamily) {
		case .accessoryInline:
			if entry.stocks.count > 0 {
				WidgetStockCell(stock: entry.stocks[0], widgetFamily:widgetFamily)
			}
		case .accessoryRectangular:
			VStack {
				ForEach(1..<4) { i in
					if entry.stocks.count > i {
						WidgetStockCell(stock: entry.stocks[i], widgetFamily:widgetFamily)
					}
				}
			}
		default:
			WidgetStockCell(stock: testStock0, widgetFamily:widgetFamily)
		}
    }
}

struct widget2EntryView : View {
	@Environment(\.widgetFamily) var widgetFamily
	var entry: Provider.Entry
	var body: some View {
		switch(widgetFamily) {
		case .accessoryRectangular:
			VStack {
				ForEach(4..<7) { i in
					if entry.stocks.count > i {
						WidgetStockCell(stock: entry.stocks[i], widgetFamily:widgetFamily)
					}
				}
			}
		default:
			WidgetStockCell(stock: testStock0, widgetFamily:widgetFamily)
		}
	}
}


@main
struct widget: WidgetBundle {
	var body: some Widget {
		widget1()
		widget2()
	}
}

struct widget1: Widget {
	let kind: String = "widget1"

	var body: some WidgetConfiguration {
		IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
			widget1EntryView(entry: entry)
		}
		.configurationDisplayName("Stock Widget")
		.description("Allow display stock widget at lock screen")
		.supportedFamilies([.accessoryInline, .accessoryRectangular])
	}
}

struct widget2: Widget {
    let kind: String = "widget2"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            widget2EntryView(entry: entry)
        }
        .configurationDisplayName("Stock Widget")
        .description("Allow display stock widget at lock screen")
		.supportedFamilies([.accessoryRectangular])
    }
}

struct widget_Previews: PreviewProvider {
    static var previews: some View {
		widget1EntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), stocks: testStockList.stocks))
			.previewContext(WidgetPreviewContext(family: .accessoryInline))
			.previewDisplayName("Inline")
		widget1EntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), stocks: testStockList.stocks))
			.previewContext(WidgetPreviewContext(family: .accessoryRectangular))
			.previewDisplayName("Rectangular")
    }
}
