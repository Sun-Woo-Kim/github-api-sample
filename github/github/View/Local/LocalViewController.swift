//
//  LocalViewController.swift
//  github
//
//  Created by Harry on 2022/03/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

class LocalViewController: UIViewController {

    private let viewModel = LocalViewModel()
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

    lazy var searchTableView: UITableView = {
        let tableView = UITableView.init()
        tableView.register(UINib(nibName: "GithubCell", bundle: nil), forCellReuseIdentifier: "GithubCell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        stackView.addArrangedSubview(searchBar)
        stackView.addArrangedSubview(tableView)
        stackView.addArrangedSubview(searchTableView)

        // Search text Observer
        searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .bind(onNext: viewModel.search(text:))
            .disposed(by: disposeBag)

        // Hide Table View
        viewModel.searchTableViewVisibleObserver
            .observe(on: MainScheduler.instance)
            .bind { [weak self] showSearchTableView in
                self?.tableView.isHidden = showSearchTableView
                self?.searchTableView.isHidden = !showSearchTableView
            }.disposed(by: disposeBag)

        // Table View section dataSource
        let dataSource = RxTableViewSectionedReloadDataSource<LocalTableViewSection>(configureCell: { dataSource, tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GithubCell", for: indexPath) as? GithubCell else {
                return .init() }

            cell.disposeBag = DisposeBag()
            cell.setItem(avatarURL: item.avatarURL, name: item.login, buttonState: .selected)

            cell.starButton.rx.tap.asDriver().drive(onNext: {
                self.viewModel.deleteItem(item)
            }).disposed(by: cell.disposeBag)

            return cell
        })

        // Seaction Header Title
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].header
        }

        // TableView Observer
        viewModel.sectionObserver
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        // SearchTableView Observer
        viewModel.searchObserver
            .observe(on: MainScheduler.instance)
            .bind(to: searchTableView.rx.items(cellIdentifier: "GithubCell", cellType: GithubCell.self)) {
            [weak self] index, item, cell in
            guard let self = self else { return }
            cell.disposeBag = DisposeBag()
            cell.setItem(avatarURL: item.avatarURL, name: item.login, buttonState: .selected)

            cell.starButton.rx.tap.asDriver().drive(onNext: {
                self.viewModel.deleteItem(item)
            }).disposed(by: cell.disposeBag)

        }.disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PersistentContainer.shared.updateItems()
    }
}
