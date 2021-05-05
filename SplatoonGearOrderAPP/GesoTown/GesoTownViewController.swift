//
//  GesoTownViewController.swift
//  SplatoonGearOrderAPP
//
//  Created by 原直也 on 2020/09/01.
//  Copyright © 2020 原直也. All rights reserved.
//

import AudioToolbox
import SafariServices
import SplatNet2
import SwiftyJSON
import UIKit
import WebKit

final class GesoTownViewController: UIViewController, FetchIksm_sessionWebViewControllerDelegate {
    private let CustomCell = "CustomCell"
    private let date = Date()
    private let dateFormatter = DateFormatter()
    private let now_day = Date(timeIntervalSinceNow: 60 * 60 * 9)
    private let UD = UserDefaults.standard

    private var refreshCtl = UIRefreshControl()
    private var session_token = ""
    private var iksm_session = ""

    private var presenter: GesoTownPresenter!

    @IBOutlet var GesoTownTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        presenter = GesoTownPresenter(view: self)
        presenter.timeFromTheRequiredUsageDate()

        GesoTownTableView.refreshControl = refreshCtl
        refreshCtl.addTarget(self, action: #selector(refreshTableView(sender:)), for: .valueChanged)
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMdHms", options: 0, locale: Locale(identifier: "ja_JP"))
    }

    @objc func refreshTableView(sender _: UIRefreshControl) {
        AudioServicesPlaySystemSound(1519)
        presenter.timeFromTheRequiredUsageDate()
        refreshCtl.endRefreshing()
    }

//    ログイン履歴がない場合にログインを促すアラート
    private func alertForRecommendLogin() {
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

    // バトル結果を取得する関数 今後実装予定
//    private func fetchBattleResultData(Iksm_session: String) {
//        let url = URL(string: "https://app.splatoon2.nintendo.net/api/results")!
//        let cookieHeader = ["Set-Cookie": Iksm_session]
//        let cookie = HTTPCookie.cookies(withResponseHeaderFields: cookieHeader, for: url)
//        HTTPCookieStorage.shared.setCookies(cookie, for: url, mainDocumentURL: url)
//
//        let task = URLSession.shared.dataTask(with: url) { (data: Data?, _: URLResponse?, _: Error?) in
//            guard let data = data else { return }
//            do {
//                let result = try JSONDecoder().decode(iksmData.self, from: data)
    ////                print(result)
//            } catch {
//                print(error)
//            }
//        }
//        task.resume()
//    }

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

// MARK: - - TableView Extension

extension GesoTownViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return presenter.GesoTownDatas.count + 1
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            GesoTownTableView.register(UINib(nibName: "SectionTableViewCell", bundle: nil), forCellReuseIdentifier: CustomCell)
            let cell = GesoTownTableView.dequeueReusableCell(withIdentifier: CustomCell) as! SectionTableViewCell
            cell.SectionNameLabel.text = "商品一覧"
            return cell
        default:
            GesoTownTableView.register(UINib(nibName: "GesoTownTableViewCell", bundle: nil), forCellReuseIdentifier: CustomCell)

            let cell = GesoTownTableView.dequeueReusableCell(withIdentifier: CustomCell) as! GesoTownTableViewCell
            cell.gesoTownInfo = presenter.GesoTownDatas[indexPath.row - 1]
            return cell
        }
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectGear = presenter.GesoTownDatas[indexPath.row - 1]

        let storyboard = UIStoryboard(name: "ItemOrder", bundle: nil)
        let itemOrderViewController = storyboard.instantiateViewController(withIdentifier: "ItemOrderViewController") as! ItemOrderViewController

        itemOrderViewController.selectGear = selectGear
        itemOrderViewController.orderedItem = presenter.orderedItem
//        present(itemOrderViewController, animated: true, completion: nil)
        navigationController?.pushViewController(itemOrderViewController, animated: true)
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}

extension GesoTownViewController: GesoTownPrsenterOutput {
    func showGesoTownGear() {
        GesoTownTableView.reloadData()
    }

    func noLoginHostory() {
        alertForRecommendLogin()
    }
}
