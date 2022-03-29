//
//  SearchViewController.swift
//  github
//
//  Created by Harry on 2022/03/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {

    private let viewModel = SearchViewModel()
    private let disposeBag = DisposeBag()

    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        return stackView
    }()

    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .prominent
        searchBar.placeholder = "검색어를 입력하세요"
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        return searchBar
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView.init()
        tableView.register(UINib(nibName: "GithubCell", bundle: nil), forCellReuseIdentifier: "GithubCell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        stackView.addArrangedSubview(searchBar)
        stackView.addArrangedSubview(tableView)

        searchBar.rx.text.orEmpty
            .throttle(.milliseconds(1500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(onNext: viewModel.search(text:))
            .disposed(by: disposeBag)

        viewModel.observer.bind(to: tableView.rx.items(cellIdentifier: "GithubCell", cellType: GithubCell.self)) {
            [weak self] index, item, cell in
            guard let self = self else { return }
            let hasInLocal = self.viewModel.hasInLocal(item: item)
            cell.disposeBag = DisposeBag()
            cell.setItem(avatarURL: item.avatarURL, name: item.login, buttonState: hasInLocal ? .selected : .normal)

            cell.starButton.rx.tap.asDriver().drive(onNext: { [weak cell] in
                if hasInLocal {
                    self.viewModel.deleteItem(item)
                } else {
                    self.viewModel.saveItem(item)
                }

                cell?.setItem(avatarURL: item.avatarURL, name: item.login, buttonState: hasInLocal ? .normal : .selected)
                
            }).disposed(by: cell.disposeBag)


        }.disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}
