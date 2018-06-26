//
//  ViewController.swift
//  Instapad
//
//  Created by Victor Melo on 25/06/18.
//  Copyright © 2018 Victor Melo. All rights reserved.
//

import UIKit
import WebKit
import GoogleMobileAds

class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var webView: WKWebView!
    var optionsButton: UIButton!
    
    
    var bannerView: GADBannerView!
    
    override func loadView() {
        super.loadView()
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self


    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWebView()
        setupBannerView()
        setupButton()
        setupInAppPurchases()
        
    }
    
    private func setupInAppPurchases() {
        IAPHandler.shared.fetchAvailableProducts()
        IAPHandler.shared.purchaseStatusBlock = {[weak self] (type) in
            guard let strongSelf = self else{ return }
            if type == .purchased {
                let alertView = UIAlertController(title: "", message: type.message(), preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                    
                })
                alertView.addAction(action)
                strongSelf.present(alertView, animated: true, completion: nil)
            }
        }
    }
    
    private func setupButton() {
        optionsButton = UIButton()
        optionsButton.setTitle("options", for: UIControlState.normal)
        optionsButton.setTitleColor(UIColor.blue, for: UIControlState.normal)
        
        view.addSubview(optionsButton)
        
        optionsButton.translatesAutoresizingMaskIntoConstraints = false
        optionsButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        optionsButton.topAnchor.constraint(equalTo: view.topAnchor, constant:70).isActive = true
        optionsButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 10).isActive = true
        optionsButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.bringSubview(toFront: optionsButton)
        
        optionsButton.addTarget(self, action: #selector(ViewController.optionsButtonTouched), for: .touchUpInside)
        
    }
    
    @objc func optionsButtonTouched() {
        
        let alert = UIAlertController(title: "About", message: "This is not an official app by Instagram Inc. All features are loaded from the official web version, published in http://www.instagram.com", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Remove Ads (~$6.99)", style: .default, handler: { action in
            
            print("removeu ads")
            IAPHandler.shared.purchaseMyProduct(index: 0)
            
         }))
        
        alert.addAction(UIAlertAction(title: "Return", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    private func setupWebView() {
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 18).isActive = true
        webView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
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

extension ViewController {
    
    private func setupBannerView() {
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        
        
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        
        if #available(iOS 11.0, *) {
            // In iOS 11, we need to constrain the view to the safe area.
            positionBannerViewFullWidthAtBottomOfSafeArea(bannerView)
        } else {
            // In lower iOS versions, safe area is not available so we use
            // bottom layout guide and view edges.
            positionBannerViewFullWidthAtBottomOfView(bannerView)
        }
        
        
//        bannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        bannerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bannerView.topAnchor.constraint(equalTo: webView.bottomAnchor).isActive = true
        
        bannerView.adUnitID = (UIApplication.shared.delegate as! AppDelegate).AD_UNIT_ID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    // MARK: - view positioning
    @available (iOS 11, *)
    func positionBannerViewFullWidthAtBottomOfSafeArea(_ bannerView: UIView) {
        // Position the banner. Stick it to the bottom of the Safe Area.
        // Make it constrained to the edges of the safe area.
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            guide.leftAnchor.constraint(equalTo: bannerView.leftAnchor),
            guide.rightAnchor.constraint(equalTo: bannerView.rightAnchor),
            guide.bottomAnchor.constraint(equalTo: bannerView.bottomAnchor)
            ])
    }
    
    func positionBannerViewFullWidthAtBottomOfView(_ bannerView: UIView) {
        
        bannerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bannerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bannerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }
}

