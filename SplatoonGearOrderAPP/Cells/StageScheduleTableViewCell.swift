//
//  StageScheduleTableViewCell.swift
//  SplatoonGearOrderAPP
//
//  Created by 原直也 on 2020/09/01.
//  Copyright © 2020 原直也. All rights reserved.
//

import UIKit

class StageScheduleTableViewCell: UITableViewCell {
    @IBOutlet var CellSpaceImageView: UIImageView!
    @IBOutlet var StageOpenTimeLabel: UILabel!

    @IBOutlet var RegularStageRuleLabel: UILabel!
    @IBOutlet var FastRegularStageNameLabel: UILabel!
    @IBOutlet var FastRegularStageImageView: UIImageView!
    @IBOutlet var SecondRegularStageNameLabel: UILabel!
    @IBOutlet var SecondRegularStageImageView: UIImageView!

    @IBOutlet var GachiStageRuleLabel: UILabel!
    @IBOutlet var FastGachiStageNameLabel: UILabel!
    @IBOutlet var FastGachiStageImageView: UIImageView!
    @IBOutlet var SecondGachiStageLabel: UILabel!
    @IBOutlet var SecondGachiStageImageView: UIImageView!

    @IBOutlet var LeagueStageRuleLabel: UILabel!
    @IBOutlet var FastLeagueStageNameLabel: UILabel!
    @IBOutlet var FastLeagueStageImageView: UIImageView!
    @IBOutlet var SecondLeagueStageNameLabel: UILabel!
    @IBOutlet var SecondLeagueStageImageView: UIImageView!

    var RegularStage: StageInfo? {
        didSet {
            RegularStageRuleLabel.font = UIFont(name: "Optima-ExtraBlack", size: 17)
            var stageImage = UIImage(named: RegularStage?.maps_ex[0].id.description ?? "1")
            FastRegularStageImageView.image = stageImage
            FastRegularStageImageView.layer.cornerRadius = 25
            FastRegularStageImageView.layer.borderColor = UIColor.rgb(red: 230, green: 230, blue: 230).cgColor
            FastRegularStageImageView.layer.borderWidth = 1

            stageImage = UIImage(named: RegularStage?.maps_ex[1].id.description ?? "1")

            SecondRegularStageImageView.image = stageImage
            SecondRegularStageImageView.layer.cornerRadius = 25
            SecondRegularStageImageView.layer.borderColor = UIColor.rgb(red: 230, green: 230, blue: 230).cgColor
            SecondRegularStageImageView.layer.borderWidth = 1

            FastRegularStageNameLabel.text = RegularStage?.maps_ex[0].name
            SecondRegularStageNameLabel.text = RegularStage?.maps_ex[1].name

            CellSpaceImageView.layer.borderWidth = 1
            CellSpaceImageView.layer.borderColor = UIColor.rgb(red: 200, green: 200, blue: 200).cgColor
            StageOpenTimeLabel.text = RegularStage?.start
            guard let start = RegularStage?.start else { return }
            guard let end = RegularStage?.end else { return }
            let stageOpenTime = StageOpenTime(start: start, end: end)
            StageOpenTimeLabel.text = stageOpenTime
        }
    }

    var GachiStage: StageInfo? {
        didSet {
            GachiStageRuleLabel.font = UIFont(name: "Optima-ExtraBlack", size: 17)
            GachiStageRuleLabel.text = GachiStage?.rule

            var stageImage = UIImage(named: GachiStage?.maps_ex[0].id.description ?? "1")
            FastGachiStageImageView.image = stageImage
            FastGachiStageImageView.layer.cornerRadius = 25
            FastGachiStageImageView.layer.borderColor = UIColor.rgb(red: 230, green: 230, blue: 230).cgColor
            FastGachiStageImageView.layer.borderWidth = 1

            stageImage = UIImage(named: GachiStage?.maps_ex[1].id.description ?? "1")
            SecondGachiStageImageView.image = stageImage
            SecondGachiStageImageView.layer.cornerRadius = 25
            SecondGachiStageImageView.layer.borderColor = UIColor.rgb(red: 230, green: 230, blue: 230).cgColor
            SecondGachiStageImageView.layer.borderWidth = 1

            FastGachiStageNameLabel.text = GachiStage?.maps_ex[0].name
            SecondGachiStageLabel.text = GachiStage?.maps_ex[1].name
        }
    }

    var LeagueStage: StageInfo? {
        didSet {
            LeagueStageRuleLabel.font = UIFont(name: "Optima-ExtraBlack", size: 17)
            LeagueStageRuleLabel.text = LeagueStage?.rule

            var stageImage = UIImage(named: LeagueStage?.maps_ex[0].id.description ?? "1")
            FastLeagueStageImageView.image = stageImage
            FastLeagueStageImageView.layer.cornerRadius = 25
            FastLeagueStageImageView.layer.borderColor = UIColor.rgb(red: 230, green: 230, blue: 230).cgColor
            FastLeagueStageImageView.layer.borderWidth = 1

            stageImage = UIImage(named: LeagueStage?.maps_ex[1].id.description ?? "1")
            SecondLeagueStageImageView.image = stageImage
            SecondLeagueStageImageView.layer.cornerRadius = 25
            SecondLeagueStageImageView.layer.borderColor = UIColor.rgb(red: 230, green: 230, blue: 230).cgColor
            SecondLeagueStageImageView.layer.borderWidth = 1

            FastLeagueStageNameLabel.text = LeagueStage?.maps_ex[0].name
            SecondLeagueStageNameLabel.text = LeagueStage?.maps_ex[1].name
        }
    }

    func StageOpenTime(start: String, end: String) -> String {
        let month = start[start.index(start.startIndex, offsetBy: 5) ..< start.index(start.startIndex, offsetBy: 7)]
        let day = start[start.index(start.startIndex, offsetBy: 8) ..< start.index(start.startIndex, offsetBy: 10)]
        let startTime = start[start.index(start.startIndex, offsetBy: 11) ..< start.index(start.startIndex, offsetBy: 16)]
        let endTime = end[end.index(end.startIndex, offsetBy: 11) ..< end.index(end.startIndex, offsetBy: 16)]

        return "\(month)月\(day)日 \(startTime)~\(endTime)"
    }
}
