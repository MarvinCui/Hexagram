//
//  HexagramActivityAttributes.swift
//  Hexagram
//
//  Created by Boran Cui on 2024/11/24.
//

#if canImport(ActivityKit) && (os(iOS) || os(macOS) && targetEnvironment(macCatalyst))
import ActivityKit
import Foundation

struct HexagramActivityAttributes: ActivityAttributes {
    // 定义动态状态
    public struct ContentState: Codable, Hashable {
        var icon: String
        var name: String
        var shortintro: String
    }

    // 定义静态属性
    var hexagramId: UUID
}
#endif
