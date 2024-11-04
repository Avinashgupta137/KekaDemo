//
//  NetworkServiceProtocol.swift
//  DemoArticle
//
//  Created by Avinash Gupta on 04/11/24.
//

import Foundation
import UIKit

protocol NetworkServiceProtocol {
    func fetch<T: Codable>(url: URL, completion: @escaping (Result<T, Error>) -> Void)
}
