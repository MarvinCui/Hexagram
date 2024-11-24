//
//  ContentView.swift
//  HexagramWatchApp Watch App
//
//  Created by Boran Cui on 2024/11/24.
//

import SwiftUI

import Foundation

struct Hexagram: Identifiable, Codable {
    let id: Int?
    let name: String
    let icon: String
    let shortintro: String
    let orginalcontent: String
    let vernacular: String
    let Duanyitianji: String
    let Originalexplain: String
}

struct SectionView: View {
    let title: String
    let content: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .bold()
            Text(content)
                .font(.body)
        }
    }
}

struct HexagramWatchContentView: View {
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
        NavigationStack {
            List(hexagrams) { hexagram in
                NavigationLink(destination: HexagramWatchDetailView(hexagram: hexagram)) {
                    HStack {
                        Text(hexagram.icon)
                            .font(.title)
                        Text(hexagram.name)
                            .font(.headline)
                            .bold()
                        Text(hexagram.shortintro)
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("六十四卦")
            .onAppear {
                loadHexagrams()
            }
        }
    }
}

struct HexagramWatchDetailView: View {
    let hexagram: Hexagram

    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                Text(hexagram.icon)
                    .font(.largeTitle)
                Text(hexagram.name)
                    .font(.headline)
                    .bold()
                Text(hexagram.shortintro)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Divider()
                VStack(alignment: .leading, spacing: 8) {
                    SectionView(title: "《易经》原文", content: hexagram.orginalcontent)
                    SectionView(title: "白话文解释", content: hexagram.vernacular)
                    SectionView(title: "《断易天机》解", content: hexagram.Duanyitianji)
                    SectionView(title: "传统解卦", content: hexagram.Originalexplain)
                }
            }
            .padding()
        }
        .navigationTitle(hexagram.name)
    }
}

struct CollapsibleSectionView: View {
    let title: String
    let content: String
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                Text(title)
                    .font(.headline)
                    .bold()
                    .foregroundColor(.blue)
            }
            if isExpanded {
                Text(content)
                    .font(.body)
                    .padding(.top, 4)
            }
        }
    }
}
