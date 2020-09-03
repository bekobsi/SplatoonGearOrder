//
//  StageScheduleTableViewCell.swift
//  SplatoonGearOrderAPP
//
//  Created by 原直也 on 2020/09/01.
//  Copyright © 2020 原直也. All rights reserved.
//

import UIKit
import SDWebImage

class StageScheduleTableViewCell: UITableViewCell {

    @IBOutlet weak var CellSpaceImageView: UIImageView!
    
    @IBOutlet weak var FastRegularStageNameLabel: UILabel!
    @IBOutlet weak var FastRegularStageImageView: UIImageView!
    @IBOutlet weak var SecondRegularStageNameLabel: UILabel!
    @IBOutlet weak var SecondRegularStageImageView: UIImageView!
    
    @IBOutlet weak var GachiStageRuleLabel: UILabel!
    @IBOutlet weak var FastGachiStageNameLabel: UILabel!
    @IBOutlet weak var FastGachiStageImageView: UIImageView!
    @IBOutlet weak var SecondGachiStageLabel: UILabel!
    @IBOutlet weak var SecondGachiStageImageView: UIImageView!
    
    
    @IBOutlet weak var LeagueStageRuleLabel: UILabel!
    @IBOutlet weak var FastLeagueStageNameLabel: UILabel!
    @IBOutlet weak var FastLeagueStageImageView: UIImageView!
    @IBOutlet weak var SecondLeagueStageNameLabel: UILabel!
    @IBOutlet weak var SecondLeagueStageImageView: UIImageView!
    
    var RegularStage: StageInfo?{
        didSet{
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
            CellSpaceImageView.layer.borderColor = UIColor.rgb(red: 180, green: 180, blue: 180).cgColor
        }
    }
    
    var GachiStage: StageInfo?{
        didSet{
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
    
    var LeagueStage: StageInfo?{
        didSet{
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

}
