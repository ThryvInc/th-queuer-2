//
//  LoginHelper.swift
//  TH Queuer
//
//  Created by Victor Zhong on 2/4/18.
//  Copyright © 2018 Thryv, Inc. All rights reserved.
//

import UIKit

class LoginHelper {
    private init () {}
    static let manager = LoginHelper()

    func makeRequest(_ username: String, _ password: String, completionHandler completion: @escaping (Data?) -> Void, errorHandler errorCallback: @escaping (Error?) -> Void) {
        var request = URLRequest(url: URL(string: AppDelegate.sessionURL)!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["username": username, "password": password], options: .prettyPrinted)
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let completionHandling = { (data: Data?) in
            guard let data = data else {
                errorCallback(AppError.noData)
                return
            }

            do {
                let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
                if let apiKey = dict?["api_key"] {
                    UserDefaults.standard.set(apiKey, forKey: "apiKey")
                } else {
                    errorCallback(AppError.wrongLoginCombo)
                }
            }

            catch {
                errorCallback(AppError.cannotParseJSON(rawError: error))
            }

            completion(data)
        }

        let errorHandling = { (error: Error?) in
            if let error = error {
                errorCallback(error)
            }
        }

        APIRequest.manager.performDataTask(.post,
                                           withURL: nil,
                                           withRequest: request,
                                           completionHandler: completionHandling,
                                           errorHandler: errorHandling)
    }

}
