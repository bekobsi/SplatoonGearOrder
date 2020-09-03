//
//  StageScheduleViewController.swift
//  SplatoonGearOrderAPP
//
//  Created by 原直也 on 2020/09/01.
//  Copyright © 2020 原直也. All rights reserved.
//

import UIKit
import Alamofire

class StageScheduleViewController: UIViewController{
    
    private let CustomCell = "CustomCell"
    private var StageCount = [StageInfo]()
    private var RegularStages = [StageInfo]()
    private var GachiStages = [StageInfo]()
    private var LeagueStages = [StageInfo]()
    
    @IBOutlet weak var StageScheduleTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        StageScheduleTableView.delegate = self
        StageScheduleTableView.dataSource = self
        StageScheduleTableView.register(UINib(nibName: "StageScheduleTableViewCell", bundle: nil),forCellReuseIdentifier:CustomCell)
        
        fetchStageInfo()
    }
    func fetchStageInfo(){
        let urlString = "https://spla2.yuu26.com/schedule"
        let request = AF.request(urlString)
        
        request.responseJSON { (response) in
            do {
                guard let data = response.data else { return }
                let decode = JSONDecoder()
                let stages = try decode.decode(Stage.self, from: data)
                self.StageCount.append(contentsOf: stages.result.regular)
                
                self.RegularStages = stages.result.regular
                self.GachiStages = stages.result.gachi
                self.LeagueStages = stages.result.league
                
                self.StageScheduleTableView.reloadData()
            } catch {
                print("変換に失敗しました",error)
            }

        }
    }
}



extension StageScheduleViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RegularStages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = StageScheduleTableView.dequeueReusableCell(withIdentifier: CustomCell)as! StageScheduleTableViewCell
        
        cell.RegularStage = RegularStages[indexPath.row]
        cell.GachiStage = GachiStages[indexPath.row]
        cell.LeagueStage = LeagueStages[indexPath.row]
            return cell
        
    }
    
}
