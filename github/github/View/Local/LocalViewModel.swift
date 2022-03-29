//
//  LocalViewModel.swift
//  github
//
//  Created by Harry on 2022/03/29.
//

import RxSwift
import Differentiator

class LocalViewModel {
    let sectionObserver: BehaviorSubject<[LocalTableViewSection]> = .init(value: [])
    let searchObserver: BehaviorSubject<[GithubItem]> = .init(value: [])
    let searchTableViewVisibleObserver: BehaviorSubject<Bool> = .init(value: false)

    private let disposeBag = DisposeBag()

    private var searchText = ""

    init() {
        PersistentContainer.shared.observer.map { githubItems -> [LocalTableViewSection] in
            var dict: [String: [GithubItem]] = [:]
            githubItems.forEach { item in
                let consonant = Util.getConsonant(text: item.login ?? "")
                dict[consonant, default: []] += [item]
            }

            let sections = dict.map { key, value in
                LocalTableViewSection(header: key,
                                      items: value.sorted(by: { $0.login?.lowercased() ?? "" < $1.login?.lowercased() ?? "" }))
            }.sorted { $0.header < $1.header }

            return sections
        }.bind { [weak self] sections in
            guard let self = self else { return }
            self.sectionObserver.onNext(sections)
            self.search(text: self.searchText)
        }.disposed(by: disposeBag)
        
    }

    func deleteItem(_ item: GithubItem) {
        PersistentContainer.shared.deleteItem(item)
        search(text: searchText)
    }

    func search(text: String) {
        searchText = text

        if text.isEmpty {
            searchTableViewVisibleObserver.onNext(false)
        } else {
            searchTableViewVisibleObserver.onNext(true)
            let filterItems = PersistentContainer.shared.githubItems
                .filter { $0.login?.lowercased().contains(text.lowercased()) == true }
                .sorted { $0.login ?? "" < $1.login ?? "" }

            searchObserver.onNext(filterItems)
        }
    }
}

// Section
struct LocalTableViewSection {
    var header: String
    var items: [GithubItem]
}

extension LocalTableViewSection: SectionModelType {
    typealias Item = GithubItem

    init(original: LocalTableViewSection, items: [GithubItem]) {
        self = original
        self.items = items
    }
}

