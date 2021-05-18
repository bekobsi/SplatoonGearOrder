//
//  FetchIksm_sessionPresenter.swift
//  SplatoonGearOrderAPP
//
//  Created by 原直也 on 2021/05/11.
//  Copyright © 2021 原直也. All rights reserved.
//

import Foundation
import RxSwift

protocol FetchIksm_sessionPresenterInput {
    func didTapAccountSelect(_ session_token_codeurl: String)
}

protocol FetchIksm_sessionPresenterOutput: AnyObject {
    func dismiss()
}

final class FetchIksm_sessionPresenter: FetchIksm_sessionPresenterInput {
    private let view: FetchIksm_sessionPresenterOutput
    private let session_token_codeURLRepository: Session_token_codeURLRepository
    private let disposeBag = DisposeBag()

    init(
        view: FetchIksm_sessionPresenterOutput,
        session_token_codeURLRepository: Session_token_codeURLRepository = Session_token_codeURLConversion()
    ) {
        self.view = view
        self.session_token_codeURLRepository = session_token_codeURLRepository
    }

    func didTapAccountSelect(_ session_token_codeURL: String) {
        session_token_codeURLRepository.get(session_token_codeURL)
            .subscribe(onSuccess: { succsess in
                if succsess {
                    self.view.dismiss()
                }
        })
            .disposed(by: disposeBag)
    }
}
