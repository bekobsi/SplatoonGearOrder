//
//  OrderingItemViewController.swift
//  SplatoonGearOrderAPP
//
//  Created by 原直也 on 2021/03/08.
//  Copyright © 2021 原直也. All rights reserved.
//

import UIKit

class OrderingItemViewController: UIViewController {
    @IBOutlet var OrderingItemTableview: UITableView!

    private let CustomCell = "CustomCell"

    var orderingItem: merchandises?
    var orderedItem: ordered_info?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }

    private func setUpViews() {
        OrderingItemTableview.delegate = self
        OrderingItemTableview.dataSource = self
//        OrderingItemTableview.register(UINib(nibName: "GesoTownTableViewCell", bundle: nil), forCellReuseIdentifier: CustomCell)

        navigationItem.title = "ギアの注文"
        let cancelBarButton = UIBarButtonItem(title: "戻る", style: .plain, target: self, action: #selector(tappedCancelButton))
        navigationItem.leftBarButtonItem = cancelBarButton
    }

    @objc func tappedCancelButton() {
        dismiss(animated: true, completion: nil)
    }
}

extension OrderingItemViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 4
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            OrderingItemTableview.register(UINib(nibName: "SectionTableViewCell", bundle: nil), forCellReuseIdentifier: CustomCell)
            let cell = OrderingItemTableview.dequeueReusableCell(withIdentifier: CustomCell) as! SectionTableViewCell
            cell.sectionName = "ギアの情報"
            return cell
        case 1:
            OrderingItemTableview.register(UINib(nibName: "GesoTownTableViewCell", bundle: nil), forCellReuseIdentifier: CustomCell)
            let cell = OrderingItemTableview.dequeueReusableCell(withIdentifier: CustomCell) as! GesoTownTableViewCell

            cell.gesoTownInfo = orderingItem
            return cell

        case 2:
            OrderingItemTableview.register(UINib(nibName: "SectionTableViewCell", bundle: nil), forCellReuseIdentifier: CustomCell)
            let cell = OrderingItemTableview.dequeueReusableCell(withIdentifier: CustomCell) as! SectionTableViewCell

            cell.sectionName = "注文中のギア"
            return cell
        case 3:
            OrderingItemTableview.register(UINib(nibName: "GesoTownTableViewCell", bundle: nil), forCellReuseIdentifier: CustomCell)
            let cell = OrderingItemTableview.dequeueReusableCell(withIdentifier: CustomCell) as! GesoTownTableViewCell

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
