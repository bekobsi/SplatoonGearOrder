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
    private var presenter: ItemOrderPresenterInput!
    func inject(presenter: ItemOrderPresenterInput) {
        self.presenter = presenter
    }

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
        ItemOrderTableview.register(UINib(nibName: "SectionTableViewCell", bundle: nil), forCellReuseIdentifier: "SectionTableViewCell")
        ItemOrderTableview.register(UINib(nibName: "GesoTownTableViewCell", bundle: nil), forCellReuseIdentifier: "GesoTownTableViewCell")
    }

    @objc func tappedCancelButton() {
        presenter.tappedCancelButton()
    }
}

extension ItemOrderViewController: ItemOrderPresenterOutput {
    func popViewController() {
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
            let cell = ItemOrderTableview.dequeueReusableCell(withIdentifier: "SectionTableViewCell") as! SectionTableViewCell
            cell.sectionName = "ギアの情報"
            return cell
        case 1:
            let cell = ItemOrderTableview.dequeueReusableCell(withIdentifier: "GesoTownTableViewCell") as! GesoTownTableViewCell

            cell.gesoTownInfo = selectGear
            return cell

        case 2:
            let cell = ItemOrderTableview.dequeueReusableCell(withIdentifier: "SectionTableViewCell") as! SectionTableViewCell

            cell.sectionName = "注文中のギア"
            return cell
        case 3:
            let cell = ItemOrderTableview.dequeueReusableCell(withIdentifier: "GesoTownTableViewCell") as! GesoTownTableViewCell

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
