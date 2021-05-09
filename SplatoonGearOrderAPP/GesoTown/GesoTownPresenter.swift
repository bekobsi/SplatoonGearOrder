//
//  GesoTownPresenter.swift
//  SplatoonGearOrderAPP
//
//  Created by 原直也 on 2021/04/24.
//  Copyright © 2021 原直也. All rights reserved.
//
//
import Foundation
import RxSwift

protocol GesoTownPresenterInput {
    func timeFromTheRequiredUsageDate()
    func didSelectRow(at indexPath: IndexPath)
}

protocol GesoTownPrsenterOutput: AnyObject {
    func noLoginHostory()
    func showGesoTownGear()
    func transitionToItemOrder(selectGear: merchandises)
}

final class GesoTownPresenter {
    private(set) var iksm_session = ""
    private(set) var orderedItem: ordered_info?
    private(set) var GesoTownDatas: [merchandises] = []

    private weak var view: GesoTownPrsenterOutput!
    private let iksm_sessionRepository: Iksm_sessionRepository
    private let gesoTownGearRepository: GesoTownGearRepository

    private let disposeBag = DisposeBag()

    private let calender = Calendar.current
    init(
        view: GesoTownPrsenterOutput,
        iksm_sessionRepository: Iksm_sessionRepository = SplatNet2Iksm_sessionRepository(),
        gesoTownGearRepository: GesoTownGearRepository = AlamofireGesoTownGearRrepository()
    ) {
        self.view = view
        self.iksm_sessionRepository = iksm_sessionRepository
        self.gesoTownGearRepository = gesoTownGearRepository
    }

    func didSelectRow(at indexPath: IndexPath) {
        let selectGear = GesoTownDatas[indexPath.row - 1]
        view.transitionToItemOrder(selectGear: selectGear)
    }

    func timeFromTheRequiredUsageDate() {
        let ud = UserDefaults.standard

        guard let lastUseDate = ud.object(forKey: "lastUseDate") as? Date else {
            print("前回の利用記録がありません")
            view.noLoginHostory()
            return
        }

        let calender = Calendar.current
        let now = Date(timeIntervalSinceNow: 60 * 60 * 9)
        let today = calender.component(.day, from: now)
        let lastUseDay = calender.component(.day, from: lastUseDate)
        if today == lastUseDay {
            print("前回利用日から日付が変わっていません")
            fetchGesoTownGearDate()
        } else {
            print("前回利用日から日付が変わっています")
            iksm_sessionUpdate()
            print("presenterIksm_session", iksm_session)
            fetchGesoTownGearDate()
        }
    }

    private func iksm_sessionUpdate() {
        iksm_sessionRepository.update()
            .subscribe(onSuccess: { iksm_session in
                self.iksm_session = iksm_session
            })
            .disposed(by: disposeBag)
    }

    private func fetchGesoTownGearDate() {
        gesoTownGearRepository.get()
            .subscribe(onSuccess: { [weak self] iksmGesoTownData in
                self?.orderedItem = iksmGesoTownData.ordered_info
                self?.GesoTownDatas = iksmGesoTownData.merchandises
                self?.view.showGesoTownGear()
            })
            .disposed(by: disposeBag)
    }
}
