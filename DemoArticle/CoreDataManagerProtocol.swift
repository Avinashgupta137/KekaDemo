//
//  CoreDataManagerProtocol.swift
//  DemoArticle
//
//  Created by Avinash Gupta on 04/11/24.
//

import Foundation
import UIKit
import CoreData

protocol CoreDataManagerProtocol {
    func saveArticle(article: Article)
    func fetchArticles() -> [ArticleEntity]
    func saveContext()
}
