//
//  StageSchedulePresenter.swift
//  SplatoonGearOrderAPP
//
//  Created by 原直也 on 2021/04/13.
//  Copyright © 2021 原直也. All rights reserved.
//

import Foundation
import RxSwift

protocol StageSchedulePresenterInput {
    var regularStages: [StageInfo] { get }
    var gachiStages: [StageInfo] { get }
    var leagueStages: [StageInfo] { get }
    func fetchStageInfo()
}

protocol StageSchedulePresenterOutput: AnyObject {
    func showStageInfo()
}

final class StageSchedulePresenter: StageSchedulePresenterInput {
    private(set) var regularStages: [StageInfo] = []
    private(set) var gachiStages: [StageInfo] = []
    private(set) var leagueStages: [StageInfo] = []

    private weak var view: StageSchedulePresenterOutput!
    private let stageRepository: StageRepositry

    private let disposeBag = DisposeBag()

    init(view: StageSchedulePresenterOutput,
         stageReposiory: StageRepositry = AlamofireStageRepository())
    {
        self.view = view
        stageRepository = stageReposiory
    }

    func fetchStageInfo() {
        stageRepository.get()
            .subscribe(onSuccess: { [weak self] stage in
                self?.regularStages = stage.result.regular
                self?.gachiStages = stage.result.gachi
                self?.leagueStages = stage.result.league

                self?.view.showStageInfo()
            })
            .disposed(by: disposeBag)
    }
}
