//
//  StageScheduleViewController.swift
//  SplatoonGearOrderAPP
//
//  Created by 原直也 on 2020/09/01.
//  Copyright © 2020 原直也. All rights reserved.
//

import Alamofire
import AudioToolbox
import UIKit

class StageScheduleViewController: UIViewController {
    let test = ["1", "2", "3", "4", "5"]

    private let CustomCell = "CustomCell"
    private var StageCount = [StageInfo]()
    private var RegularStages = [StageInfo]()
    private var GachiStages = [StageInfo]()
    private var LeagueStages = [StageInfo]()

    private let refreshCtl = UIRefreshControl()
    private var indicatorBackgroundView: UIView!
    private var indicator: UIActivityIndicatorView!

    @IBOutlet var StageScheduleTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        StageScheduleTableView.delegate = self
        StageScheduleTableView.dataSource = self
        StageScheduleTableView.register(UINib(nibName: "StageScheduleTableViewCell", bundle: nil), forCellReuseIdentifier: CustomCell)
        StageScheduleTableView.refreshControl = refreshCtl
        refreshCtl.addTarget(self, action: #selector(refreshTableView(sender:)), for: .valueChanged)
        fetchStageInfo()
    }

    override func viewWillAppear(_ animated: Bool) {
        fetchStageInfo()
    }

    func fetchStageInfo() {
        showIndicator()
        let urlString = "https://spla2.yuu26.com/schedule"
        let request = AF.request(urlString)

        request.responseJSON { response in
            do {
                guard let data = response.data else { return }
                let decode = JSONDecoder()
                let stages = try decode.decode(Stage.self, from: data)
                self.StageCount.append(contentsOf: stages.result.regular)

                self.RegularStages = stages.result.regular
                self.GachiStages = stages.result.gachi
                self.LeagueStages = stages.result.league

                self.StageScheduleTableView.reloadData()
                self.StageScheduleTableView.alpha = 1
            } catch {
                print("変換に失敗しました", error)
            }
        }
        indicator?.stopAnimating()
        indicatorBackgroundView.alpha = 0
    }

    @objc func refreshTableView(sender: UIRefreshControl) {
        StageScheduleTableView.reloadData()
        AudioServicesPlaySystemSound(1519)
        refreshCtl.endRefreshing()
    }

    func showIndicator() {
        StageScheduleTableView.alpha = 0
        // インジケータビューの背景
        indicatorBackgroundView = UIView(frame: view.bounds)
        indicatorBackgroundView.backgroundColor = UIColor.black
        indicatorBackgroundView.alpha = 0.4
        indicatorBackgroundView?.tag = 100100

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

extension StageScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RegularStages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = StageScheduleTableView.dequeueReusableCell(withIdentifier: CustomCell) as! StageScheduleTableViewCell

        cell.RegularStage = RegularStages[indexPath.row]
        cell.GachiStage = GachiStages[indexPath.row]
        cell.LeagueStage = LeagueStages[indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}
