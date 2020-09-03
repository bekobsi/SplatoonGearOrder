//
//  GesoTownViewController.swift
//  SplatoonGearOrderAPP
//
//  Created by 原直也 on 2020/09/01.
//  Copyright © 2020 原直也. All rights reserved.
//

import UIKit
import SafariServices
import WebKit

class GesoTownViewController: UIViewController {
    
    @IBOutlet weak var webOpenButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        webOpenButton.addTarget(self, action: #selector(openURL), for: .touchUpInside)
    }
    @objc func openURL(){
        let storyboard = UIStoryboard(name: "FetchIksm_sessionWebView", bundle: nil)
        let fetchIksm_sessionWebViewController = storyboard.instantiateViewController(withIdentifier: "FetchIksm_sessionWebViewController")as! FetchIksm_sessionWebViewController
        let nav = UINavigationController(rootViewController: fetchIksm_sessionWebViewController)
  
        self.present(nav, animated: true, completion: nil)
    }
}
