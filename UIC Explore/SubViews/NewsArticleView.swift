//
//  NewsArticleView.swift
//  UIC Explore
//
//  Created by Jovani Trejo on 6/5/24.
//

import SwiftUI

struct NewsArticleView: View {
    let article: NewsArticle
    var body: some View {
        HStack {
            VStack (alignment: .leading) {
                HStack {
                    Text(article.title)
                    .font(.headline)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                Text(formatDate(dateString: article.pubDate))
                    .font(.footnote)
            }
            Spacer()
            if let imageURL = article.imageURL, let url = URL(string: imageURL) {
                AsyncImage(url: url, content: { image in
                    Rectangle()
                        .aspectRatio(1.5, contentMode: .fill)
                        .frame(width: 130, height: 75)
                        .overlay(content: {
                            image
                                .resizable()
                                .scaledToFill()
                        })
                        .cornerRadius(5)
                }, placeholder: {
                    ProgressView()
                })
            }
        }
        .safeAreaPadding()
    }
}

#Preview {
    NewsArticleView(article: testArticleWithImage)
}
