//
//  ArticleViewModelProtocol.swift
//  DemoArticle
//
//  Created by Avinash Gupta on 04/11/24.
//
import Foundation
import UIKit
import Combine

protocol ArticleViewModelProtocol {
    var filteredArticles: Published<[ArticleEntity]>.Publisher { get }
    func fetchArticles()
    func loadCachedData()
}
