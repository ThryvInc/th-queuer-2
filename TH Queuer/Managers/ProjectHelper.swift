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

    // This request GETS a list of projects from the API
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

        APIRequest.manager.performDataTask(withURL: nil, withRequest: request, completionHandler: completionHandling, errorHandler: errorHandling)
    }

    // This POSTs a new project to the API for the logged in user
    func createProject(_ projectName: String, completionHandler completion: @escaping (Data?) -> Void, errorHandler errorHandle: @escaping (Error?) -> Void) {
        guard let apiKey = UserDefaults.standard.string(forKey: "apiKey") else { return }

        var request = URLRequest(url: URL(string: AppDelegate.projectsURL)!)

        request.httpBody = try? JSONSerialization.data(withJSONObject: ["project" : ["name": projectName, "color": -13508189]], options: .prettyPrinted)
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue(apiKey, forHTTPHeaderField: "X-Qer-Authorization")
        request.httpMethod="POST"
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

        APIRequest.manager.performDataTask(withURL: nil, withRequest: request, completionHandler: completionHandling, errorHandler: errorHandling)
    }
}
