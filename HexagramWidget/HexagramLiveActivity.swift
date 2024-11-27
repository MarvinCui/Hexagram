//
//  HexagramLiveActivity.swift
//  Hexagram
//
//  Created by Boran Cui on 2024/11/24.
//

#if canImport(ActivityKit) && (os(iOS) || os(macOS) && targetEnvironment(macCatalyst))
import WidgetKit
import ActivityKit
import SwiftUI
import Foundation


// 定义 Live Activity 小组件
struct HexagramLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: HexagramActivityAttributes.self) { context in
            // 锁屏和小型动态岛 UI
            VStack(alignment: .leading) {
                Text(context.state.icon)
                    .font(.largeTitle)
                Text(context.state.name)
                    .font(.headline)
                Text(context.state.shortintro)
                    .font(.subheadline)
            }
            .padding()
        } dynamicIsland: { context in
            DynamicIsland {
                // 展开后的 UI
                DynamicIslandExpandedRegion(.leading) {
                    Text(context.state.icon)
                        .font(.title)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.state.name)
                        .font(.headline)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text(context.state.shortintro)
                        .font(.body)
                }
            } compactLeading: {
                Text(context.state.icon)
            } compactTrailing: {
                Text(context.state.name)
            } minimal: {
                Text(context.state.icon)
            }
        }
    }
}
#endif
