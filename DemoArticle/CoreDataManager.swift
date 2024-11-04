//
//  CoreDataManager.swift
//  DemoArticle
//
//  Created by Avinash on 04/11/24.
//

import CoreData
import UIKit

class CoreDataManager: CoreDataManagerProtocol {
    static let shared = CoreDataManager()
    private init() {}

    lazy var context: NSManagedObjectContext = {
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }()

    func saveArticle(article: Article) {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "ArticleEntity", into: context) as! ArticleEntity
        entity.title = article.headline.main
        entity.abstract = article.abstract
        entity.pubDate = ISO8601DateFormatter().date(from: article.pubDate)
        if let urlString = article.multimedia.first?.url {
            entity.imageUrl = "https://www.nytimes.com/\(urlString)"
        }
        saveContext()
    }
    
    func fetchArticles() -> [ArticleEntity] {
        let request: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch articles: \(error)")
            return []
        }
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
