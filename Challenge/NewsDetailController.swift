//
//  NewsDetailController.swift
//  Challenge
//
//  Created by Nikita Merkel on 10/10/2018.
//  Copyright © 2018 Nikita Merkel. All rights reserved.
//

import UIKit
import SVProgressHUD

class NewsDetailController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var teaserLabel: UILabel!
    @IBOutlet weak var textView: UITextViewFixed!
    
    var newsId: Int?
    var data: NewsClass?
    var activityIndicator : UIActivityIndicatorView?
    lazy var currentFontSize: CGFloat = 14.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let id = newsId else { return }
        
        setupNavBar()
        configureActivityIndicator()
        isSubviewsHidden(value: true)
        getNews(byId: id)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        shouldSetNavbarTransparent(true)
        scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        shouldSetNavbarTransparent(false)
    }
    
    private func setupNavBar() {
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "ic_back")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "ic_back")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_fontsize"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(changeFontsize))
    }
    
    private func shouldSetNavbarTransparent(_ value: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = value
    }
    
    private func configureActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator?.hidesWhenStopped = true
        activityIndicator?.center = self.view.center
        
        self.view.addSubview(activityIndicator!)
        
        activityIndicator?.startAnimating()
    }
    
    private func isSubviewsHidden(value: Bool) {
        view.subviews.forEach { $0.isHidden = value }
    }
    
    private func getNews(byId id: Int) {
        APIClient.shared().getNews(byId: id) { (isSuccess, errorMessage, response) in
            if isSuccess {
                guard let newsData = response?.data?.news else { return }
                self.data = newsData
                self.setupView()
            } else {
                SVProgressHUD.showError(withStatus: errorMessage)
            }
        }
    }
    
    private func setupView() {
        if let newsData = data {
            isSubviewsHidden(value: false)
            self.activityIndicator?.stopAnimating()
            
            newsImage.imageFromServerURL(newsData.imageURL ?? "", placeHolder: nil)
            themeLabel.text = newsData.newsCategory?.title?.uppercased() ?? "Неизвестно"
            titleLabel.text = newsData.title ?? "Нет заголовка"
            dateLabel.text = Utils.convertDate(newsData.createdAt)
            teaserLabel.text = newsData.teaser ?? "Нет тизера"
            textView.attributedText = newsData.text?.htmlAttributedString()
        }
    }
    
    @objc private func changeFontsize() {
        if currentFontSize == 22.0 {
            textView.attributedText = data!.text?.htmlAttributedString()
            currentFontSize = 14.0
        } else {
            textView.attributedText = data!.text?.htmlAttributedString(fontSize: currentFontSize + 4.0)
            currentFontSize += 4.0
        }
    }
}

extension NewsDetailController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var offset = scrollView.contentOffset.y / 150
        let color =  #colorLiteral(red: 0.2470588235, green: 0.7294117647, blue: 0.8235294118, alpha: 1).withAlphaComponent(offset)
        
        if offset > 1 {
            offset = 1
        }
        
        self.navigationController?.navigationBar.backgroundColor = color
        UIApplication.shared.statusBarView?.backgroundColor = color
    }
}
