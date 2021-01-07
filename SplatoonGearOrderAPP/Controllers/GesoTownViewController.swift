//
//  GesoTownViewController.swift
//  SplatoonGearOrderAPP
//
//  Created by 原直也 on 2020/09/01.
//  Copyright © 2020 原直也. All rights reserved.
//

import SafariServices
import SplatNet2
import SwiftyJSON
import UIKit
import WebKit
class GesoTownViewController: UIViewController, FetchIksm_sessionWebViewControllerDelegate {
    let date = Date()
    let dateFormatter = DateFormatter()
    
    var session_token = ""
    var iksm_session = ""
    
    let now_day = Date(timeIntervalSinceNow: 60 * 60 * 9)
    let UD = UserDefaults.standard
    
    @IBOutlet var webOpenButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        webOpenButton.addTarget(self, action: #selector(openWebview), for: .touchUpInside)
        
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMdHms", options: 0, locale: Locale(identifier: "ja_JP"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        session_token = UD.string(forKey: "session_token") ?? ""
        TimeFromTheRequiredUsageDate()
        iksm_session = UD.string(forKey: "iksm_session") ?? ""
        print("iksm_session", iksm_session)
        fetchBattleResultData(Iksm_session: iksm_session)
        fetchGesoTownData(Iksm_session: iksm_session)
    }
    
//    前回利用日から1日経過しているかを判別するメソッド
    private func TimeFromTheRequiredUsageDate() {
        let calender = Calendar.current
        
//        前回利用日から今後の処理を分岐
        if UD.object(forKey: "lastUseDate") != nil {
            let lastUseDate = UD.object(forKey: "lastUseDate") as! Date
            let now = calender.component(.day, from: now_day)
            let LastUseDate = calender.component(.day, from: lastUseDate)
            
            if now != LastUseDate {
                print("前回利用日から日付が変わっています")
                do {
                    iksm_session = try SplatNet2.genIksmSession(session_token)["iksm_session"].stringValue
                    UD.set(iksm_session, forKey: "iksm_session")
                    UD.set(now_day, forKey: "lastUseDate")
//                    tableviewを更新するメソッド
                } catch {
                    print("iksm_sessionの取得に失敗しました")
                }
            } else {
                print("前回利用日から日付が変わっていません")
            }
        } else {
            print("前回の利用記録がありません")
//            アラートのタイトルとメッセージの指定
            let alert = UIAlertController(title: "アカウントが設定されていません", message: "この機能を利用するためにはログインが必要です\nアカウントを設定しますか？", preferredStyle: UIAlertController.Style.alert)
//            OKボタン
            let defaultAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (_: UIAlertAction!) -> Void in
                self.openWebview()
                print("OK")
            })
//            キャンセルボタン
            let cancelAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: { (_: UIAlertAction!) -> Void in
                print("Cancel")
            })
            alert.addAction(cancelAction)
            alert.addAction(defaultAction)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    private func fetchBattleResultData(Iksm_session: String) {
        let url = URL(string: "https://app.splatoon2.nintendo.net/api/results")!
        let cookieHeader = ["Set-Cookie": Iksm_session]
        let cookie = HTTPCookie.cookies(withResponseHeaderFields: cookieHeader, for: url)
        HTTPCookieStorage.shared.setCookies(cookie, for: url, mainDocumentURL: url)

        let task = URLSession.shared.dataTask(with: url) { (data: Data?, _: URLResponse?, _: Error?) in
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(iksmData.self, from: data)
//                print(result)
            } catch let e {
                print(e)
            }
        }
        task.resume()
    }
    
    private func fetchGesoTownData(Iksm_session: String) {
        let url = URL(string: "https://app.splatoon2.nintendo.net/api/onlineshop/merchandises")!
        let cookieHeder = ["Set-cookie": Iksm_session]
        let cookie = HTTPCookie.cookies(withResponseHeaderFields: cookieHeder, for: url)
        HTTPCookieStorage.shared.setCookies(cookie, for: url, mainDocumentURL: url)

        let task = URLSession.shared.dataTask(with: url) { (data: Data?, _: URLResponse?, _: Error?) in
            guard let data = data else { return }
            do {
                let GesoTownData = try JSONDecoder().decode(iksmGesoTownData.self, from: data)
                print("GesoTownData", GesoTownData.merchandises[0].gear.name)
            } catch let e {
                print(e)
            }
        }
        task.resume()
    }

    @objc func openWebview() {
        let storyboard = UIStoryboard(name: "FetchIksm_sessionWebView", bundle: nil)
        let fetchIksm_sessionWebViewController = storyboard.instantiateViewController(withIdentifier: "FetchIksm_sessionWebViewController") as! FetchIksm_sessionWebViewController
        let nav = UINavigationController(rootViewController: fetchIksm_sessionWebViewController)
        nav.modalPresentationStyle = .fullScreen
        fetchIksm_sessionWebViewController.delegate = self
        present(nav, animated: true, completion: nil)
    }

    func returnData(session_token: String, iksm_session: String) {
        UD.set(iksm_session, forKey: "iksm_session")
        UD.set(session_token, forKey: "session_token")
        UD.set(now_day, forKey: "lastUseDate")
    }
}
