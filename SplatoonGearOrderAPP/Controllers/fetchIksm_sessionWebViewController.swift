//
//  FetchIksm_sessionWebViewController.swift
//  SplatoonGearOrderAPP
//
//  Created by 原直也 on 2020/09/03.
//  Copyright © 2020 原直也. All rights reserved.
//

import Alamofire
import SplatNet2
import SwiftyJSON
import UIKit
import WebKit

protocol FetchIksm_sessionWebViewControllerDelegate {
    func returnData(session_token: String, iksm_session: String)
}

class FetchIksm_sessionWebViewController: UIViewController, WKNavigationDelegate {
    private let createNintendoLoginPageURL = CreateNintendoLoginPageURL()
    private let iksm = Iksm()
    private var auth_code_verifer = ""
    private var session_token_code = ""

    private var indicatorBackgroundView: UIView!
    private var indicator: UIActivityIndicatorView!
    private var response = JSON()
    private var userdefaults = UserDefaults.standard

    var delegate: FetchIksm_sessionWebViewControllerDelegate?
    @IBOutlet var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self

        setUpViews()
        if userdefaults.string(forKey: "session_token") == "" {
            print("session_tokenが取得されていません")
        } else {
            print("session_tokenが取得完了")
            openWebview()
        }
    }

    // webViewNavigationInfo
    private func setUpViews() {
        webView.navigationDelegate = self
        let leftBarButton = UIBarButtonItem(title: "戻る", style: .plain, target: self, action: #selector(tappedNavLeftBarButton))
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.leftBarButtonItem?.tintColor = .black
    }

    @objc func tappedNavLeftBarButton() {
        dismiss(animated: true, completion: nil)
    }

    private func openWebview() {
        let url = URL(string: createNintendoLoginPageURL.urlselfEncode())

        let urlRequest = URLRequest(url: url!)
        webView.load(urlRequest)
    }

    func webView(_: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
    {
        guard let session_token_codeURL = navigationAction.request.url?.absoluteString else { return }
        if session_token_codeURL.contains("session_token_code=") == true {
            print("session_token_code取得に成功しました。:", session_token_codeURL)
            do {
                fetchSession_token_code(session_token_codeURL: session_token_codeURL)
                auth_code_verifer = createNintendoLoginPageURL.randomStringCreate(createLength: 50, numberPullOut: true)
                print("session_token_codeが生成されました:", session_token_code)
                print("auth_code_verifer:", auth_code_verifer)
                response = try SplatNet2.getSessionToken(session_token_code, auth_code_verifer)
                let session_token = response["session_token"].stringValue

                let iksm_session = try SplatNet2.genIksmSession(session_token)["iksm_session"].stringValue
                print("iksm_session", iksm_session)

                delegate?.returnData(session_token: session_token, iksm_session: iksm_session)
                dismiss(animated: true, completion: nil)
            } catch {
                print("catchが呼ばれました", error)
            }
        }
        print("session_token_codeの取得に失敗しました")
        decisionHandler(.allow)
    }

    func fetchSession_token_code(session_token_codeURL: String) {
        var count = 0
        while session_token_codeURL.prefix(count).contains("session_token_code=") == false {
            count += 1
        }
        session_token_code = String(session_token_codeURL.dropFirst(count))
        count = 0
        while session_token_codeURL.dropLast(count).contains("&state=") == true {
            count += 1
        }
        session_token_code = String(session_token_code.dropLast(count + 6))
    }

    func showIndicator() {
        // インジケータビューの背景
        indicatorBackgroundView = UIView(frame: view.bounds)
        indicatorBackgroundView.backgroundColor = UIColor.black
        indicatorBackgroundView.alpha = 0.4
        indicatorBackgroundView?.tag = 100_100

        indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator?.center = view.center
        indicator?.color = UIColor.white
        // アニメーション停止と同時に隠す設定
        indicator?.hidesWhenStopped = true

        // 作成したviewを表示
        indicatorBackgroundView?.addSubview(indicator!)
        view.addSubview(indicatorBackgroundView!)

        indicator?.startAnimating()
    }
}
