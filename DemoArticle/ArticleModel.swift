//
//  ArticleModel.swift
//  DemoArticle
//
//  Created by Avinash on 04/11/24.
//
import Foundation

struct ArticleResponse: Codable {
    let response: ArticleDocs
}

struct ArticleDocs: Codable {
    let docs: [Article]
}

struct Article: Codable {
    let headline: Headline
    let abstract: String
    let pubDate: String
    let multimedia: [Media]
    
    enum CodingKeys: String, CodingKey {
        case headline, abstract
        case pubDate = "pub_date"
        case multimedia
    }
}

struct Headline: Codable {
    let main: String
}

struct Media: Codable {
    let url: String
}
