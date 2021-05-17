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

protocol FetchIksm_sessionViewControllerDelegate {
    func returnData(session_token: String, iksm_session: String)
}

class FetchIksm_sessionViewController: UIViewController, WKNavigationDelegate {
    private let createNintendoLoginPageURL = CreateNintendoLoginPageURL()
    private let iksm = Iksm()

    private var indicatorBackgroundView: UIView!
    private var indicator: UIActivityIndicatorView!
    private var response = JSON()

    private var presenter: FetchIksm_sessionPresenterInput!
    func inject(presenter: FetchIksm_sessionPresenterInput) {
        self.presenter = presenter
    }

    var delegate: FetchIksm_sessionViewControllerDelegate?
    @IBOutlet var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        inject(presenter: FetchIksm_sessionPresenter(view: self))
        setUpViews()
        openWebview()
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
        let url = URL(string: "https://accounts.nintendo.com/connect/1.0.0/authorize?state=_99o_shMs0SHNSzPUSS_W-H0Ni6-5Zurlske9J3LVrVp78rC&redirect_uri=npf71b963c1b7b6d119%3A%2F%2Fauth&client_id=71b963c1b7b6d119&scope=openid+user+user.birthday+user.mii+user.screenName&response_type=session_token_code&session_token_code_challenge=36tApCjTUbr8O9Pf8GCogPIZ3_PKERD-xtgOZbQKjOk&session_token_code_challenge_method=S256&theme=login_form")

        let urlRequest = URLRequest(url: url!)
        webView.load(urlRequest)
    }

    func webView(_: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void){
        guard let session_token_codeurl = navigationAction.request.url?.absoluteString else { return }
        presenter.didTapAccountSelect(session_token_codeurl)
        decisionHandler(.allow)
    }
}

extension FetchIksm_sessionViewController: FetchIksm_sessionPresenterOutput {
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}
