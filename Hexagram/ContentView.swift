//
//  ContentView.swift
//  Hexagram
//
//  Created by Boran Cui on 2024/11/24.
//
//  易经数据采用 https://www.zhouyi.cc/zhouyi/yijing64 中的内容

import SwiftUI

// 数据模型
struct Hexagram: Identifiable, Codable {
    let id = UUID() // 唯一标识符
    let name: String // 卦名
    let icon: String // 图形
    let shortintro: String //四字解释，如“刚健中正“
    let orginalcontent: String //易经原文
    let vernacular: String //白话文解释
    let Duanyitianji: String //《断易天机》解
    let Originalexplain: String //传统解卦
}

// ContentView
struct ContentView: View {
    // 动态加载的卦数据
    @State private var hexagrams: [Hexagram] = []
    
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


    var body: some View {
        NavigationView {
            ZStack {
                // 渐变背景
                LinearGradient(
                    gradient: Gradient(colors: [Color("BackgroundStart"), Color("BackgroundEnd")]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                // 卡片式列表
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(hexagrams) { hexagram in
                            NavigationLink(destination: HexagramDetailView(hexagram: hexagram)) {
                                HStack {
                                    Text(hexagram.icon)
                                        .font(.largeTitle)
                                        .frame(width: 50, height: 50)
                                        .background(
                                            Circle()
                                                .fill(Color("IconBackground"))
                                        )
                                    VStack(alignment: .leading) {
                                        Text(hexagram.name)
                                            .font(.headline)
                                            .foregroundColor(Color("TextPrimary"))
                                        Text(hexagram.shortintro)
                                            .font(.subheadline)
                                            .foregroundColor(Color("TextSecondary"))
                                    }
                                    Spacer()
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color("CardBackground"))
                                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 4)
                                )
                                .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .navigationTitle("六十四卦速查") // 设置标题
            .onAppear {
                loadHexagrams() // 视图加载时加载 JSON 数据
            }
        }
    }
}

//详情页面
struct HexagramDetailView: View {
    let hexagram: Hexagram

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 渐变背景：覆盖整个页面，包括顶部的导航栏
                LinearGradient(
                    gradient: Gradient(colors: [Color("BackgroundStart"), Color("BackgroundEnd")]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea() // 确保渐变背景覆盖屏幕和安全区域

                VStack(spacing: 20) {
                    // 标题区，包括图标、标题、简介
                    HStack(alignment: .center, spacing: 16) {
                        Spacer() // 左侧间距，确保整体居中

                        // 图标
                        Text(hexagram.icon)
                            .font(.system(size: geometry.size.width * 0.1)) // 动态字体大小，基于屏幕宽度
                            .frame(width: geometry.size.width * 0.15, height: geometry.size.width * 0.15)
                            .background(
                                Circle()
                                    .fill(Color("IconBackground"))
                            )

                        // 标题和简介
                        VStack(alignment: .center, spacing: 4) {
                            Text(hexagram.name)
                                .font(.system(size: geometry.size.width * 0.05)) // 动态调整标题大小
                                .bold()
                                .foregroundColor(Color("TextPrimary"))
                                .multilineTextAlignment(.center) // 居中对齐标题文字
                            Text(hexagram.shortintro)
                                .font(.system(size: geometry.size.width * 0.035)) // 动态调整简介大小
                                .foregroundColor(Color("TextSecondary"))
                                .multilineTextAlignment(.center) // 居中对齐简介文字
                        }

                        Spacer() // 右侧间距，确保整体居中
                    }
                    .frame(maxWidth: .infinity) // 确保标题区在整个页面中居中
                    
                    Divider()
                        .background(Color("DividerColor"))

                    // 内容区
                    VStack(alignment: .leading, spacing: 16) {
                        SectionView(
                            title: "《易经》原文",
                            content: hexagram.orginalcontent,
                            titleFont: .system(size: geometry.size.width * 0.04), // 动态标题字体
                            contentFont: .system(size: geometry.size.width * 0.035) // 动态内容字体
                        )
                        SectionView(
                            title: "白话文解释",
                            content: hexagram.vernacular,
                            titleFont: .system(size: geometry.size.width * 0.04),
                            contentFont: .system(size: geometry.size.width * 0.035)
                        )
                        SectionView(
                            title: "《断易天机》解",
                            content: hexagram.Duanyitianji,
                            titleFont: .system(size: geometry.size.width * 0.04),
                            contentFont: .system(size: geometry.size.width * 0.035)
                        )
                        SectionView(
                            title: "传统解卦",
                            content: hexagram.Originalexplain,
                            titleFont: .system(size: geometry.size.width * 0.04),
                            contentFont: .system(size: geometry.size.width * 0.035)
                        )
                    }
                }
                .padding(20) // 文字内容的统一间距
                .background(
                    RoundedRectangle(cornerRadius: 20) // 增大圆角矩形
                        .fill(Color("CardBackground"))
                        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                        .padding(.horizontal, 16) // 保证背景左右两侧的留白
                )
                .padding(.horizontal) // 整体内容相对屏幕的左右间距
            }
            .navigationBarTitleDisplayMode(.inline) // 将标题居中
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(hexagram.name)
                        .font(.system(size: geometry.size.width * 0.05)) // 动态调整导航栏标题字体大小
                        .foregroundColor(Color("TextPrimary"))
                        .bold()
                }
            }
        }
    }
}

// 分区视图
struct SectionView: View {
    let title: String
    let content: String
    let titleFont: Font // 动态标题字体
    let contentFont: Font // 动态内容字体

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(titleFont) // 使用动态标题字体
                .foregroundColor(Color("TextPrimary"))
            Text(content)
                .font(contentFont) // 使用动态内容字体
                .foregroundColor(Color("TextSecondary"))
        }
    }
}

// 预览
#Preview {
    ContentView()
}
