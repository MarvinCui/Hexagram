//
//  HexagramWidgetBundle.swift
//  HexagramWidget
//
//  Created by Boran Cui on 2024/11/24.
//

import WidgetKit
import SwiftUI
import ActivityKit
import Foundation

@main
struct HexagramWidgetBundle: WidgetBundle {
    var body: some Widget {
        HexagramWidget() // 注册静态小组件
        HexagramLiveActivity() // 注册动态岛活动（如果存在）
    }
}
