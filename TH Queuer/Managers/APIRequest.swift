//
//  APIRequest.swift
//  TH Queuer
//
//  Created by Victor Zhong on 2/4/18.
//  Copyright © 2018 Thryv, Inc. All rights reserved.
//

import Foundation

class APIRequest {
    private init () {}
    static let manager = APIRequest()
    private let session = URLSession(configuration: .default)

    func performDataTask(_ method: RequestType, withURL url: URL?,
                         withRequest request: URLRequest?,
                         completionHandler: @escaping (Data) -> Void,
                         errorHandler: @escaping (Error) -> Void) {
        switch method {
        case .post:
            if let request = request {
                session.dataTask(with: request, completionHandler: { (data, response, error) in
                    DispatchQueue.main.async {
                        if let error = error {
                            errorHandler(error)
                            return
                        }

                        if let data = data {
                            completionHandler(data)
                        }
                    }
                }).resume()
            }

        case .get:
            if let url = url {
                session.dataTask(with: url, completionHandler: { (data, response, error) in
                    DispatchQueue.main.async {
                        if let error = error {
                            errorHandler(error)
                            return
                        }

                        if let response = response as? HTTPURLResponse {
                            if response.statusCode != 200 {
                                errorHandler(AppError.badResponseCode(code: response.statusCode))
                            }
                        }

                        if let data = data {
                            completionHandler(data)
                        }
                    }
                }).resume()
            }
        }
    }

}
