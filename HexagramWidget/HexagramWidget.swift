import WidgetKit
import SwiftUI
import Foundation

struct Hexagram: Identifiable, Codable {
    let id: Int
    let name: String
    let icon: String
    let shortintro: String
    let orginalcontent: String
    let vernacular: String
    let Duanyitianji: String
    let Originalexplain: String
}

struct HexagramEntry: TimelineEntry {
    let date: Date // 当前时间
    let hexagram: Hexagram // 卦象数据
}

struct HexagramWidget: Widget {
    let kind: String = "HexagramWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HexagramProvider()) { entry in
            HexagramWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("六十四卦小组件")
        .description("自动切换六十四卦的卦象信息。")
        .supportedFamilies([.systemSmall, .systemMedium]) // 支持的小组件大小
    }
}

struct HexagramProvider: TimelineProvider {
    // 卦象数据加载逻辑
    func loadHexagrams() -> [Hexagram] {
        if let url = Bundle.main.url(forResource: "HexagramData", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decodedHexagrams = try JSONDecoder().decode([Hexagram].self, from: data)
                return decodedHexagrams
            } catch {
                print("加载 JSON 数据失败: \(error)")
            }
        }
        return []
    }
    
    func placeholder(in context: Context) -> HexagramEntry {
        // 卦象占位符
        HexagramEntry(date: Date(), hexagram: Hexagram(id: 0, name: "乾卦", icon: "☰", shortintro: "刚健中正", orginalcontent: "", vernacular: "", Duanyitianji: "", Originalexplain: ""))
    }
    
    func getSnapshot(in context: Context, completion: @escaping (HexagramEntry) -> Void) {
        let hexagrams = loadHexagrams()
        let randomHexagram = hexagrams.randomElement() ?? placeholder(in: context).hexagram
        completion(HexagramEntry(date: Date(), hexagram: randomHexagram))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<HexagramEntry>) -> Void) {
        let hexagrams = loadHexagrams() // 加载所有卦象数据
        var entries: [HexagramEntry] = []
        
        let interval: TimeInterval = 60 * 60 * 3 // 每 3 小时切换一次
        var currentDate = Date()
        
        // 生成随机的时间点对应的条目
        for _ in 0..<10 { // 假设生成未来 30 小时内的条目
            let randomHexagram = hexagrams.randomElement() ?? placeholder(in: context).hexagram
            let entry = HexagramEntry(date: currentDate, hexagram: randomHexagram)
            entries.append(entry)
            currentDate += interval
        }
        
        // 创建时间线，策略为到达结束时
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct HexagramWidgetEntryView: View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: HexagramProvider.Entry

    var body: some View {
        ZStack {
            //  小组件背景
            Color.white
                .containerBackground(Color.white, for: .widget)
            
            if widgetFamily == .systemSmall {
                // 小尺寸小组件
                VStack(spacing: 8) {
                    Text(entry.hexagram.icon)
                        .font(.system(size: 40))
                        .foregroundColor(Color("IconColor"))
                    Text(entry.hexagram.name)
                        .font(.headline)
                        .bold()
                        .foregroundColor(Color("TitleColor"))
                    Text(entry.hexagram.shortintro)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .lineLimit(2) // 限制为两行
                }
                .padding()
            } else if widgetFamily == .systemMedium {
                // 中尺寸小组件
                HStack(spacing: 16) {
                    Text(entry.hexagram.icon)
                        .font(.system(size: 60))
                        .foregroundColor(Color("IconColor"))

                    VStack(alignment: .leading, spacing: 8) {
                        Text(entry.hexagram.name)
                            .font(.headline)
                            .bold()
                            .foregroundColor(Color("TitleColor"))

                        Text(entry.hexagram.shortintro)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)

                        Divider() // 分割线

                        Text(entry.hexagram.Originalexplain)
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .lineLimit(3) // 限制显示三行
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true) // 允许文本块垂直扩展
                    }
                }
                .padding()
            }
        }
    }
}
