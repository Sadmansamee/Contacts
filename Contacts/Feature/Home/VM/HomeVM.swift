//
//  HomeViewModel.swift
//  Contacts
//
//  Created by sadman samee on 10/9/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import Moya
import RxRelay
import RxSwift
import SwiftyJSON

final class HomeVM {
    private var homeProvider: MoyaProvider<HomeService>

    private let _isLoading = BehaviorRelay(value: false)

    private let _alertMessage = PublishSubject<AlertMessage>()
    private let _cells = BehaviorRelay<[ContactViewModel]>(value: [])

    var onShowingLoading: Observable<Bool> {
        _isLoading.asObservable()
            .distinctUntilChanged()
    }

    var onShowAlert: Observable<AlertMessage> {
        _alertMessage.asObservable()
    }

    var cells: Observable<[ContactViewModel]> {
        _cells.asObservable()
    }

    init(homeProvider: MoyaProvider<HomeService>) {
        self.homeProvider = homeProvider
    }

    func fetchContactss(isRefresh _: Bool = false, isLoadingMore _: Bool = false) {
        _isLoading.accept(true)

        homeProvider.request(.contacts, completion: { result in

            self._isLoading.accept(false)

            if case let .success(response) = result {
                do {
                    let filteredResponse = try response.filterSuccessfulStatusCodes()

                    let json = JSON(filteredResponse.data)

                    let items = json.arrayValue.compactMap {
                        Contact(fromJson: $0)
                    }

                    let data = self._cells.value + items

                    self._cells.accept(data)

                } catch {
                    self._alertMessage.onNext(AlertMessage(title: error.localizedDescription, message: ""))
                }
            } else {
                self._alertMessage.onNext(AlertMessage(title: result.error?.errorDescription, message: ""))
            }
        })
    }
}
