//
//  ArticleViewController.swift
//  MobilliumProject
//
//  Created by Yarkın Gazibaba on 22.05.2022.
//

import UIKit
import WebKit

class ArticleViewController: UIViewController {
    
    var article:String?
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let url = URL(string: article ?? "https://www.google.com")!
                let urlRequest = URLRequest(url: url)

                webView.load(urlRequest)
                webView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
                view.addSubview(webView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    
    func configure(with model: WebArticleViewModel) {
        guard let url = URL(string: "\(model.article)") else {return}
        webView.load(URLRequest(url: url))
    }
    
    
}
