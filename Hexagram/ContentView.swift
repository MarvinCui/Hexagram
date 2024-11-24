//
//  ContentView.swift
//  Hexagram
//
//  Created by Boran Cui on 2024/11/24.
//
//  数据来源：https://www.zhouyi.cc/zhouyi/yijing64
//  触发 Dynamic Island 函数：triggerDynamicIsland

import SwiftUI
import Foundation
import ActivityKit

// 数据模型
struct Hexagram: Identifiable, Codable {
    let id = UUID() // 唯一标识符
    let name: String // 卦名
    let icon: String // 图形
    let shortintro: String // 四字解释
    let orginalcontent: String // 易经原文
    let vernacular: String // 白话文解释
    let Duanyitianji: String // 《断易天机》解
    let Originalexplain: String // 传统解卦

    private enum CodingKeys: String, CodingKey {
        case name
        case icon
        case shortintro
        case orginalcontent
        case vernacular
        case Duanyitianji
        case Originalexplain
    }
}

// 主界面
struct ContentView: View {
    @State private var hexagrams: [Hexagram] = []
    @State private var selectedHexagramID: UUID?
    @State private var searchText: String = ""

    // 从 JSON 文件加载数据
    func loadHexagrams() {
        if let url = Bundle.main.url(forResource: "HexagramData", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decodedHexagrams = try JSONDecoder().decode([Hexagram].self, from: data)
                hexagrams = decodedHexagrams
            } catch {
                print("加载 JSON 数据失败: \(error)")
            }
        } else {
            print("找不到 JSON 文件")
        }
    }

    // 根据搜索文本过滤数据
    var filteredHexagrams: [Hexagram] {
        if searchText.isEmpty {
            return hexagrams
        } else {
            return hexagrams.filter { $0.name.contains(searchText) }
        }
    }

    var body: some View {
        NavigationSplitView {
            List(selection: $selectedHexagramID) {
                ForEach(filteredHexagrams) { hexagram in
                    NavigationLink(value: hexagram.id) {
                        HStack(spacing: 16) {
                            Text(hexagram.icon)
                                .font(.largeTitle)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(hexagram.name)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Text(hexagram.shortintro)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // 确保 hexagrams 数组不为空
                        guard !hexagrams.isEmpty else {
                            print("没有可用的卦象数据")
                            return
                        }
                        // 随机选择一个卦象
                        if let randomHexagram = hexagrams.randomElement() {
                            // 更新选中的卦象 ID，以便界面同步显示
                            selectedHexagramID = randomHexagram.id
                            // 调用 triggerDynamicIsland 函数
                            triggerDynamicIsland(hexagram: randomHexagram)
                        } else {
                            print("随机选择卦象失败")
                        }
                    }) {
                        Image(systemName: "dice")
                    }
                }
            }
            .navigationTitle("六十四卦速查")
            .onAppear {
                loadHexagrams()
            }
            .searchable(text: $searchText, prompt: "搜索卦名") // 添加搜索功能
        } detail: {
            if let selectedHexagramID = selectedHexagramID,
               let hexagram = hexagrams.first(where: { $0.id == selectedHexagramID }) {
                HexagramDetailView(hexagram: hexagram)
            } else {
                Text("请选择你需要的卦象")
                    .foregroundColor(.secondary)
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationSplitViewStyle(.balanced)
    }
}


// 详情页面
struct HexagramDetailView: View {
    let hexagram: Hexagram

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // 标题
                HStack(alignment: .top, spacing: 16) {
                    Text(hexagram.icon)
                        .font(.system(size: 60))
                    VStack(alignment: .leading, spacing: 8) {
                        Text(hexagram.name)
                            .font(.title2)
                            .bold()
                            .foregroundColor(.primary)
                        Text(hexagram.shortintro)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                Divider() // 分割线
                // 内容
                SectionView(title: "《易经》原文", content: hexagram.orginalcontent)
                SectionView(title: "白话文解释", content: hexagram.vernacular)
                SectionView(title: "《断易天机》解", content: hexagram.Duanyitianji)
                SectionView(title: "传统解卦", content: hexagram.Originalexplain)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationTitle(hexagram.name)
        #if os(iOS) || os(watchOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        
    }
}

// 分区视图
struct SectionView: View {
    let title: String
    let content: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            Text(content)
                .font(.body)
                .foregroundColor(.primary)
        }
        .padding(.bottom, 16)
    }
}

// 预览
#Preview {
    ContentView()
}

extension ContentView {
    func triggerDynamicIsland(hexagram: Hexagram) {
        let attributes = HexagramActivityAttributes(hexagramId: hexagram.id)
        let initialState = HexagramActivityAttributes.ContentState(
            icon: hexagram.icon,
            name: hexagram.name,
            shortintro: hexagram.shortintro
        )
        
        // 定义活动内容，有效期为30秒
        let activityContent = ActivityContent(state: initialState, staleDate: Date().addingTimeInterval(30))
        
        do {
            _ = try Activity<HexagramActivityAttributes>.request(attributes: attributes, content: activityContent)
            print("成功启动 Dynamic Island")
        } catch {
            print("启动 Dynamic Island 失败: \(error)")
        }
    }
}
