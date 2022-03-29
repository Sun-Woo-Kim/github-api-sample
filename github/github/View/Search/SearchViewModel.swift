//
//  SearchViewModel.swift
//  github
//
//  Created by Harry on 2022/03/29.
//

import RxSwift

class SearchViewModel {
    let observer: BehaviorSubject<[Item]> = .init(value: [])

    func search(text: String) {
        NetworkManager.shared.request(text: text) { [weak self] items in
            self?.observer.onNext(items)
        }
    }

    func hasInLocal(item: Item) -> Bool {
        PersistentContainer.shared.githubItems.first { $0.login == item.login
        } != nil
    }

    func saveItem(_ item: Item) {
        PersistentContainer.shared.saveContext(item: item)
    }

    func deleteItem(_ item: Item) {
        PersistentContainer.shared.deleteItem(item)
    }
}
