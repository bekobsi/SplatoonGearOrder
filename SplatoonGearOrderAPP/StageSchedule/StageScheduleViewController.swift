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

final class StageScheduleViewController: UIViewController {
    private let refreshCtl = UIRefreshControl()
    private var presenter: StageSchedulePresenter!

    @IBOutlet var StageScheduleTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter = StageSchedulePresenter(view: self)
        presenter.fetchStageInfo()
    }

    private func setup() {
        StageScheduleTableView.register(UINib(nibName: "StageScheduleTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        StageScheduleTableView.refreshControl = refreshCtl
        refreshCtl.addTarget(self, action: #selector(refreshTableView(sender:)), for: .valueChanged)
    }

    @objc func refreshTableView(sender _: UIRefreshControl) {
        presenter.fetchStageInfo()
        AudioServicesPlaySystemSound(1519)
        refreshCtl.endRefreshing()
    }
}

extension StageScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return presenter.regularStages.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = StageScheduleTableView.dequeueReusableCell(withIdentifier: "CustomCell") as! StageScheduleTableViewCell

        cell.RegularStage = presenter.regularStages[indexPath.row]
        cell.GachiStage = presenter.gachiStages[indexPath.row]
        cell.LeagueStage = presenter.leagueStages[indexPath.row]

        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 300
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}

extension StageScheduleViewController: StageSchedulePresenterOutput {
    func showStageInfo() {
        StageScheduleTableView.reloadData()
    }
}
