//
//  MainViewController.swift
//  github
//
//  Created by Harry on 2022/03/22.
//

import UIKit
import Tabman
import Pageboy
import CoreData

class MainViewController: TabmanViewController {
 
    private var viewControllers = [SearchViewController(), LocalViewController()]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        let bar = TMBar.ButtonBar()
        bar.layout.contentMode = .fit
        bar.layout.transitionStyle = .snap
        bar.subviews.last?.backgroundColor = .white
        addBar(bar, dataSource: self, at: .navigationItem(item: self.navigationItem))
    }
}

extension MainViewController: PageboyViewControllerDataSource, TMBarDataSource {

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }

    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }

    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: "API")
        case 1:
            return TMBarItem(title: "로컬")
        default:
            return TMBarItem(title: "")
        }
    }
}






