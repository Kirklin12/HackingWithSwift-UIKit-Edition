//
//  WebViewController.swift
//  Project16
//
//  Created by Mike on 2019-10-30.
//  Copyright © 2019 Mike. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    var placeName: String!
    var url: URL!
    var webView: WKWebView!

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeName = placeName.replacingOccurrences(of: " ", with: "_")
 
        url = URL(string: "https://en.wikipedia.org/wiki/" + placeName)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
}
