//
//  HexagramActivityAttributes.swift
//  Hexagram
//
//  Created by Boran Cui on 2024/11/24.
//

import ActivityKit
import Foundation

// 定义活动属性
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
