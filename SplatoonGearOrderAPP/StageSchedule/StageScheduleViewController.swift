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
    @IBOutlet private var stageScheduleTableView: UITableView!

    private let refreshCtl = UIRefreshControl()

    private var presenter: StageSchedulePresenterInput!
    func inject(presenter: StageSchedulePresenterInput) {
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
//        inject(presenter: StageSchedulePresenter(view: self))
        presenter.fetchStageInfo()
    }

    private func setup() {
        stageScheduleTableView.register(UINib(nibName: "StageScheduleTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        stageScheduleTableView.refreshControl = refreshCtl
        refreshCtl.addTarget(self, action: #selector(refreshTableView(sender:)), for: .valueChanged)
    }

    @objc func refreshTableView(sender _: UIRefreshControl) {
        presenter.fetchStageInfo()
        AudioServicesPlaySystemSound(1519)
        refreshCtl.endRefreshing()
    }
}

// MARK: - StageScheduleTableView Extension

extension StageScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return presenter.regularStages.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = stageScheduleTableView.dequeueReusableCell(withIdentifier: "CustomCell") as! StageScheduleTableViewCell

        cell.regularStage = presenter.regularStages[indexPath.row]
        cell.gachiStage = presenter.gachiStages[indexPath.row]
        cell.leagueStage = presenter.leagueStages[indexPath.row]

        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 300
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}

// MARK: - StageSchedulePresenterOutput Extension

extension StageScheduleViewController: StageSchedulePresenterOutput {
    func showStageInfo() {
        stageScheduleTableView.reloadData()
    }
}
