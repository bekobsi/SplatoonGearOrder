//
//  OrderingItemViewController.swift
//  SplatoonGearOrderAPP
//
//  Created by 原直也 on 2021/03/08.
//  Copyright © 2021 原直也. All rights reserved.
//

import UIKit

class ItemOrderViewController: UIViewController {
    @IBOutlet var ItemOrderTableview: UITableView!

    private let dateFormatter = DateFormatter()

    private let CustomCell = "CustomCell"

    var selectGear: merchandises?
    var orderedItem: ordered_info?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }

    private func setUpViews() {
        navigationItem.title = "ギアの注文"
        let cancelBarButton = UIBarButtonItem(title: "戻る", style: .plain, target: self, action: #selector(tappedCancelButton))
        navigationItem.leftBarButtonItem = cancelBarButton
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMdHms", options: 0, locale: Locale(identifier: "ja_JP"))
    }

    @objc func tappedCancelButton() {
        navigationController?.popViewController(animated: true)
    }
}

extension ItemOrderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 4
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            ItemOrderTableview.register(UINib(nibName: "SectionTableViewCell", bundle: nil), forCellReuseIdentifier: CustomCell)
            let cell = ItemOrderTableview.dequeueReusableCell(withIdentifier: CustomCell) as! SectionTableViewCell
            cell.sectionName = "ギアの情報"
            return cell
        case 1:
            ItemOrderTableview.register(UINib(nibName: "GesoTownTableViewCell", bundle: nil), forCellReuseIdentifier: CustomCell)
            let cell = ItemOrderTableview.dequeueReusableCell(withIdentifier: CustomCell) as! GesoTownTableViewCell

            cell.gesoTownInfo = selectGear
            return cell

        case 2:
            ItemOrderTableview.register(UINib(nibName: "SectionTableViewCell", bundle: nil), forCellReuseIdentifier: CustomCell)
            let cell = ItemOrderTableview.dequeueReusableCell(withIdentifier: CustomCell) as! SectionTableViewCell

            cell.sectionName = "注文中のギア"
            return cell
        case 3:
            ItemOrderTableview.register(UINib(nibName: "GesoTownTableViewCell", bundle: nil), forCellReuseIdentifier: CustomCell)
            let cell = ItemOrderTableview.dequeueReusableCell(withIdentifier: CustomCell) as! GesoTownTableViewCell

            cell.orderedInfo = orderedItem
            return cell
        default:
            break
        }
        let cell: UITableViewCell! = nil
        return cell
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}
