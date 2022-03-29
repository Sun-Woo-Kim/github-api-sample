//
//  NetworkManager.swift
//  github
//
//  Created by Harry on 2022/03/29.
//

import Foundation
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()

    func request(text: String, completion: @escaping ([Item]) -> ()) {
        let url = "https://api.github.com/search/users?q=" + text

        AF.request(url)
            .responseDecodable(of: GitHubResponse.self) { response in
                debugPrint(response)
                completion(response.value?.items ?? [])
            }
    }
}
