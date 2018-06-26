//
//  ViewController.swift
//  Instapad
//
//  Created by Victor Melo on 25/06/18.
//  Copyright © 2018 Victor Melo. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        super.loadView()
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        let css = "background-color : #000"
        
        let js = "var instaDownload = document.getElementsByClassName('MFkQJ')[0]; instaDownload.style.visibility = 'hidden'; instaDownload.style.height = '0px';"
        
        webView.evaluateJavaScript(js, completionHandler: nil)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 18).isActive = true
        webView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        let myURL = URL(string:"https://www.instagram.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        webView.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("var instaDownload = document.getElementsByClassName('MFkQJ')[0]; instaDownload.style.visibility = 'hidden'; instaDownload.style.height = '0px'; var instaDownload2 = document.getElementsByClassName('fP5IM')[0]; instaDownload2.style.visibility = 'hidden'; instaDownload2.style.height = '0px';")  { (_, _) in
            webView.isHidden = false
        }
        
    }

    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

