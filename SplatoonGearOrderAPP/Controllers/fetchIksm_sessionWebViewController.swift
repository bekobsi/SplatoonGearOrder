//
//  FetchIksm_sessionWebViewController.swift
//  SplatoonGearOrderAPP
//
//  Created by 原直也 on 2020/09/03.
//  Copyright © 2020 原直也. All rights reserved.
//

import UIKit
import WebKit

class FetchIksm_sessionWebViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        openURL()
        setUpViews()
    }
    
    private func setUpViews(){
        webView.navigationDelegate = self
        let leftBarButton = UIBarButtonItem(title: "戻る", style: .plain, target: self, action: #selector(tappedNavLeftBarButton))
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    @objc func tappedNavLeftBarButton(){
        dismiss(animated: true, completion: nil)
    }
    
    private func openURL(){
       let url = URL(string: "https://accounts.nintendo.com/connect/1.0.0/authorize?state=Idc97CVVWgKJDWc0bHnoiP4c4n7CBaRZlwzrbASxSmXF7T-L&redirect_uri=npf71b963c1b7b6d119%3A%2F%2Fauth&client_id=71b963c1b7b6d119&scope=openid+user+user.birthday+user.mii+user.screenName&response_type=session_token_code&session_token_code_challenge=CDKP2ggs9yYY6q3bgcAsCY4dlJRWXgHSVrUUTKePoU8&session_token_code_challenge_method=S256&theme=login_form")
        let urlRequest = URLRequest(url: url!)
        webView.load(urlRequest)
    }
    func webView(_ webView: WKWebView,
    decidePolicyFor navigationAction: WKNavigationAction,
    decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let url = navigationAction.request.url?.absoluteString else { return }
        print("リンクが押されました",url)
        if url.contains("//auth#session_state=") == true {
            print("アカウント認証が成功しました")
        }
        decisionHandler(.allow)
    }
}
