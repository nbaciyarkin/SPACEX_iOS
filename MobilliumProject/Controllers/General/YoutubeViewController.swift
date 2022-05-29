//
//  YoutubeViewController.swift
//  MobilliumProject
//
//  Created by Yarkın Gazibaba on 20.05.2022.
//

import UIKit
import WebKit

class YoutubeViewController: UIViewController {
    private var articleUrl:String?
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.text = "Launch Detail"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .regular)
        label.textColor = .white
        label.layer.masksToBounds = true
        return label
    }()
    
    private let launchNameLabel: UILabel = {
        let label  = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "Harry Potter"
        label.textColor = .white
        return label
    }()
    
    private let overViewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.text = "This is the best movie ever to watch as a kid"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let downloadButton: UIButton = {
         let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(named: "article_button")
        button.setTitle("READ ARTICLE", for: .normal)
        button.addTarget(self, action: #selector(btn_TUI), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        return button
    }()
    
    let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(white: 0.2, alpha: 0.9)
        v.alwaysBounceVertical = true
        v.layer.cornerRadius = 12
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(scrollView)
        view.addSubview(webView)
        view.addSubview(launchNameLabel)
        view.addSubview(detailLabel)
        scrollView.addSubview(overViewLabel)
        view.addSubview(downloadButton)
        
        configureConstraints()
    }
    
    @objc func btn_TUI(){
        DispatchQueue.main.async {
            let vc = ArticleViewController()
            vc.article = self.articleUrl
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func configureConstraints(){
        let scrollViewConstraints = [
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 10),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -10),
            scrollView.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 10),
            scrollView.heightAnchor.constraint(equalToConstant: 200),
        ]
        let webViewConstraints = [
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            webView.heightAnchor.constraint(equalToConstant: 200)
        ]
        let titleLabelConstraints = [
            launchNameLabel.topAnchor.constraint(equalTo: webView.bottomAnchor,constant: 10),
            launchNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            launchNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]
        let detailLabelConstraints = [
            detailLabel.topAnchor.constraint(equalTo: launchNameLabel.bottomAnchor, constant: 10),
            detailLabel.heightAnchor.constraint(equalToConstant: 25),
            detailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        let overViewLabelConstraints = [
            overViewLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            overViewLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 20),
            overViewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 15),
            overViewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -15),
        ]
        let downloadButtonConstraints = [
            downloadButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            downloadButton.topAnchor.constraint(equalTo:scrollView.bottomAnchor,constant: 30),
            downloadButton.widthAnchor.constraint(equalToConstant: 150),
            downloadButton.heightAnchor.constraint(equalToConstant: 30)
        ]
        NSLayoutConstraint.activate(scrollViewConstraints)
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(detailLabelConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(overViewLabelConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    
    func configure(with model: LaunchPreviewViewModel) {
        articleUrl = model.articleLink
        launchNameLabel.text = model.title
        overViewLabel.text = "\(model.launchDetail)"
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId)") else {return}
        webView.load(URLRequest(url: url))
    }
}
