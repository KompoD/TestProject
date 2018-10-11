//
//  NewsController.swift
//  Challenge
//
//  Created by Nikita Merkel on 10/10/2018.
//  Copyright © 2018 Nikita Merkel. All rights reserved.
//

import UIKit
import SVProgressHUD

class NewsCell: UITableViewCell {
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
}

class NewsController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var newsList: [News] = [] {
        didSet {
            if newsList.count > 0 {
                tableView.tableFooterView = nil
            }
            tableView.reloadData()
        }
    }
    
    var activityIndicator: UIActivityIndicatorView?
    var totalNews = 0
    var loadedNews = 0
    var loadPage = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        configureActivityIndicator()
        getNews(atPage: 1, cleanArray: false)
    }
    
    private func configureActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator?.hidesWhenStopped = true
        activityIndicator?.center = self.view.center
        tableView.tableFooterView = UIView()
        
        self.view.addSubview(activityIndicator!)
        
        activityIndicator?.startAnimating()
    }
    
    private func getNews(atPage page: Int, cleanArray: Bool) {
        APIClient.shared().getNews(page: page) { (isSuccess, errorMessage, response) in
            if isSuccess {
                guard let news = response?.data?.news else { return }
                self.activityIndicator?.stopAnimating()
                
                if cleanArray {
                    self.newsList = news
                } else {
                    self.newsList.append(contentsOf: news)
                }
                
                self.totalNews = (response?.data?.meta?.totalCount!)!
            } else {
                SVProgressHUD.showError(withStatus: errorMessage)
            }
        }
    }
    
    @IBAction func refreshButtonTapped(_ sender: UIBarButtonItem) {
        getNews(atPage: 1, cleanArray: true)
    }
}

extension NewsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell") as! NewsCell
        
        let currentNews = newsList[indexPath.row]
        
        cell.themeLabel.text = currentNews.newsCategory?.title?.uppercased() ?? "НЕИЗВЕСТНО"
        cell.titleLabel.text = currentNews.title ?? "Нет заголовка"
        cell.dateLabel.text = Utils.convertDate(currentNews.createdAt)
        cell.newsImage.imageFromServerURL(currentNews.imageURL ?? "", placeHolder: nil)
        
        return cell
    }
}

extension NewsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailController") as! NewsDetailController
        detailController.newsId = newsList[indexPath.row].id
        navigationController?.pushViewController(detailController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if shouldRequestMorePosts(indexPath: indexPath) {
            self.getNews(atPage: self.loadPage, cleanArray: false)
            self.loadPage += 1
            self.loadedNews += 20
        }
    }
    
    private func shouldRequestMorePosts(indexPath: IndexPath) -> Bool {
        guard !newsList.isEmpty else { return false }
        
        let lastRow = newsList.count - 1
        let remainingNews = totalNews - loadedNews
        
        return indexPath.row == lastRow && remainingNews > 0
    }
}
