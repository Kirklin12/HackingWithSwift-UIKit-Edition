//
//  DetailViewController.swift
//  Project38
//
//  Created by Mike on 2020-05-29.
//  Copyright © 2020 Mike. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var detailItem: Commit?
        
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let detail = self.detailItem {
            let url = URL(string: detail.url)!
            webView.load(URLRequest(url: url))
        }
    }
}
