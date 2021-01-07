//
//  StageScheduleTableViewCell.swift
//  SplatoonGearOrderAPP
//
//  Created by 原直也 on 2020/09/01.
//  Copyright © 2020 原直也. All rights reserved.
//

import SDWebImage
import UIKit

class StageScheduleTableViewCell: UITableViewCell {
    @IBOutlet var CellSpaceImageView: UIImageView!
    @IBOutlet var StageOpenTimeLabel: UILabel!
    
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
            var imageURL = URL(string: RegularStage?.maps_ex[0].image ?? "")
            FastRegularStageImageView.sd_setImage(with: imageURL)
            FastRegularStageImageView.layer.cornerRadius = 25
            FastRegularStageImageView.layer.borderColor = UIColor.rgb(red: 230, green: 230, blue: 230).cgColor
            FastRegularStageImageView.layer.borderWidth = 1
            
            imageURL = URL(string: RegularStage?.maps_ex[1].image ?? "")
            SecondRegularStageImageView.sd_setImage(with: imageURL)
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
            GachiStageRuleLabel.text = GachiStage?.rule
            
            var imageURL = URL(string: GachiStage?.maps_ex[0].image ?? "")
            FastGachiStageImageView.sd_setImage(with: imageURL)
            FastGachiStageImageView.layer.cornerRadius = 25
            FastGachiStageImageView.layer.borderColor = UIColor.rgb(red: 230, green: 230, blue: 230).cgColor
            FastGachiStageImageView.layer.borderWidth = 1
            
            imageURL = URL(string: GachiStage?.maps_ex[1].image ?? "")
            SecondGachiStageImageView.sd_setImage(with: imageURL)
            SecondGachiStageImageView.layer.cornerRadius = 25
            SecondGachiStageImageView.layer.borderColor = UIColor.rgb(red: 230, green: 230, blue: 230).cgColor
            SecondGachiStageImageView.layer.borderWidth = 1
            
            FastGachiStageNameLabel.text = GachiStage?.maps_ex[0].name
            SecondGachiStageLabel.text = GachiStage?.maps_ex[1].name
        }
    }
    
    var LeagueStage: StageInfo? {
        didSet {
            LeagueStageRuleLabel.text = LeagueStage?.rule
            
            var imageURL = URL(string: LeagueStage?.maps_ex[0].image ?? "")
            FastLeagueStageImageView.sd_setImage(with: imageURL)
            FastLeagueStageImageView.layer.cornerRadius = 25
            FastLeagueStageImageView.layer.borderColor = UIColor.rgb(red: 230, green: 230, blue: 230).cgColor
            FastLeagueStageImageView.layer.borderWidth = 1
            
            imageURL = URL(string: LeagueStage?.maps_ex[1].image ?? "")
            SecondLeagueStageImageView.sd_setImage(with: imageURL)
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
