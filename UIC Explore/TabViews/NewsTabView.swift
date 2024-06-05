//
//  NewsTabView.swift
//  UIC Explore
//
//  Created by Jovani Trejo on 6/5/24.
//

import SwiftUI

struct NewsTabView: View {
    @State private var articles: [NewsArticle] = []
    @State var selectedFilter = "All"
    var allFilters: [String] = ["All", "Campus News", "Academic and Research", "Official Communications", "Announcements", "Events"]
    var body: some View {
        if articles.isEmpty {
            ProgressView()
                .onAppear(perform: {
                    fetchUICToday(filter: selectedFilter) { result in
                        switch result {
                        case .success(let data):
                            RSSParser().parse(data: data) { items in
                                DispatchQueue.main.async {
                                    self.articles = items
                                }
                            }
                        case .failure(let error):
                            print("Failed to fetch RSS feed: \(error.localizedDescription)")
                        }
                    }
                })
        } else {
            VStack {
                Text("UIC Today")
                    .font(.title3)
                    .bold()
                HStack {
                    Picker("All", selection: $selectedFilter) {
                        ForEach(allFilters, id: \.self) { filter in
                            Text(filter)
                        }
                    }
                    Spacer()
                }
                ScrollView {
                    ForEach(articles, id: \.link) { article in
                        let trimmedLink = article.link.trimmingCharacters(in: .whitespacesAndNewlines)
                        Link(destination: URL(string: trimmedLink)!, label: {
                            NewsArticleView(article: article)
                        })
                        .buttonStyle(PlainButtonStyle())
                        Divider()
                    }
                }
                .onChange(of: selectedFilter, {
                    fetchUICToday(filter: selectedFilter) { result in
                        switch result {
                        case .success(let data):
                            RSSParser().parse(data: data) { items in
                                DispatchQueue.main.async {
                                    self.articles = items
                                }
                            }
                        case .failure(let error):
                            print("Failed to fetch RSS feed: \(error.localizedDescription)")
                        }
                    }
                })
                Spacer()
            }
        }
            
    }
}

#Preview {
    NewsTabView()
}
