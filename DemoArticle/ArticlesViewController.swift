//
//  ViewController.swift
//  DemoArticle
//
//  Created by Avinash on 04/11/24.
//

import UIKit
import Combine

class ArticlesViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    private let viewModel = ArticleViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        viewModel.$filteredArticles
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
            .store(in: &cancellables)
//        if NetworkMonitor.shared.isConnected {
            viewModel.fetchArticles()
//        } else {
//            viewModel.loadCachedData()
//        }
    }
    private func setupTableView() {
        tableView.dataSource = self
    }
}

extension ArticlesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as? ArticleCell else {
            return UITableViewCell()
        }
        
        let article = viewModel.filteredArticles[indexPath.row]
        cell.lblTitle.text = article.title
        cell.lblDescription.text = article.abstract
        cell.lblDate.text = formattedDate(from: article.pubDate)
        
        if let imageUrl = article.imageUrl {
            cell.imgPoster.setImage(from: "\(imageUrl)")
        } else {
            cell.imgPoster.image = UIImage(systemName: "photo")
        }
        
        return cell
    }
    
    private func formattedDate(from date: Date?) -> String {
        guard let date = date else { return "" }
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "yyyy-MM-dd"
        return displayFormatter.string(from: date)
    }
    
    
}

extension UIImageView {
    func setImage(from urlString: String?, placeholder: UIImage? = UIImage(systemName: "photo")) {
        self.image = placeholder
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Failed to load image: \(error)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Invalid image data")
                return
            }
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
