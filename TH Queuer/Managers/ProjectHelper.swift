//
//  ProjectHelper.swift
//  TH Queuer
//
//  Created by Victor Zhong on 2/5/18.
//  Copyright © 2018 Thryv, Inc. All rights reserved.
//

import UIKit

class ProjectHelper {
    private init () {}
    static let manager = ProjectHelper()

    func makeRequest(completionHandler completion: @escaping (Data?) -> Void, errorHandler errorHandle: @escaping (Error?) -> Void) {
        guard let apiKey = UserDefaults.standard.string(forKey: "apiKey") else { return }

        var request = URLRequest(url: URL(string: AppDelegate.projectsURL)!)
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue(apiKey, forHTTPHeaderField: "X-Qer-Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let completionHandling = { (data: Data?) in
            if let data = data {
                completion(data)
            }
        }

        let errorHandling = { (error: Error?) in
            if let error = error {
                errorHandle(error)
            }
        }

        APIRequest.manager.performDataTask(.post, withURL: nil, withRequest: request, completionHandler: completionHandling, errorHandler: errorHandling)
    }
}
