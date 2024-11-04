//
//  ViewModel.swift
//  DemoArticle
//
//  Created by Avinash on 04/11/24.
//

import Foundation
import Combine

class ArticleViewModel {
    private let networkService: NetworkServiceProtocol
    var articles: [ArticleEntity] = []
    @Published var filteredArticles: [ArticleEntity] = []
    
    init(networkService: NetworkServiceProtocol = NYTNetworkManager()) {
        self.networkService = networkService
    }
    
    func fetchArticles() {
        let url = URL(string: "https://api.nytimes.com/svc/search/v2/articlesearch.json?q=election&api-key=j5GCulxBywG3lX211ZAPkAB8O381S5SM")!
        
        networkService.fetch(url: url) { [weak self] (result: Result<ArticleResponse, Error>) in
            switch result {
            case .success(let response):
                // Save articles to CoreData (only unique ones will be saved)
                response.response.docs.forEach { article in
                    CoreDataManager.shared.saveArticle(article: article)
                }
                // Fetch the updated list from CoreData
                self?.articles = CoreDataManager.shared.fetchArticles()
                
                // Sort and publish the articles
                self?.sortAndPublish()
                
            case .failure(let error):
                print("Failed to fetch data: \(error)")
            }
        }
    }
    
    func loadCachedData() {
        articles = CoreDataManager.shared.fetchArticles()
        sortAndPublish()
    }
    
    private func sortAndPublish() {
        filteredArticles = articles.sorted { ($0.pubDate ?? Date()) > ($1.pubDate ?? Date()) }
    }
}
