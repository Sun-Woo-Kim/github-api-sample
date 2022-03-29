//
//  PersistentContainer.swift
//  github
//
//  Created by Harry on 2022/03/29.
//

import CoreData
import RxSwift

class PersistentContainer: NSPersistentContainer {

    let observer: BehaviorSubject<[GithubItem]> = .init(value: [])

    private(set) var githubItems: [GithubItem] = []

    static let shared: PersistentContainer = {
        let container = PersistentContainer(name: "github")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext(item: Item) {
        let githubItem = GithubItem(context: viewContext)
        githubItem.login = item.login
        githubItem.avatarURL = item.avatarURL
        githubItem.url = item.url
        do {
            try viewContext.save()
            updateItems()

        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
            assertionFailure()
        }
    }
    
    func updateItems() {
        let request: NSFetchRequest<GithubItem> = GithubItem.fetchRequest()
        do {
            let items = try viewContext.fetch(request)
            observer.onNext(items)
            githubItems = items
        } catch {
            return
        }
    }

    func deleteItem(_ item: Item) {
        guard let githubItem = githubItems.first(where: { $0.login == item.login }) else { return }
        viewContext.delete(githubItem)
        do {
            try viewContext.save()
            updateItems()
        } catch {
            assertionFailure()
        }
    }

    func deleteItem(_ githubItem: GithubItem) {
        viewContext.delete(githubItem)
        do {
            try viewContext.save()
            updateItems()
        } catch {
            assertionFailure()
        }
    }
}
