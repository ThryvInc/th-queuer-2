//
//  ProjectsViewController.swift
//  TH Queuer
//
//  Created by Elliot Schrock on 2/3/18.
//  Copyright © 2018 Thryv, Inc. All rights reserved.
//

import UIKit

class ProjectsViewController: UIViewController {
    //MARK: - Properties and Outlets
    @IBOutlet weak var tableView: UITableView!
    var projects: [[String : AnyObject?]]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    var selectedProject = [String : AnyObject?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Projects"

        // TableView Setup
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "project")

        // View Setup
        addRightBarButton()
        loadData()
    }
    
    //MARK: - ViewController Functions and Methods
    func loadData() {
        let completion = { (data: Data?) in
            if let data = data {
                guard let serializedData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [[String : AnyObject?]] else {
                    ErrorMessage.manager.presentErrorMessage(.noData, self)
                    return
                }

                self.projects = serializedData
            }
        }

        let errorHandling = { (error: Error?) in
            if let error = error as? AppError {
                ErrorMessage.manager.presentErrorMessage(error, self)
            }
        }

        ProjectHelper.manager.makeRequest(completionHandler: completion, errorHandler: errorHandling)
    }
    
    func addRightBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForProjectCreation))
    }

    @objc func promptForProjectCreation() {
        let vc = UIAlertController(title: "Project name", message: nil, preferredStyle: .alert)
        
        vc.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            vc.dismiss(animated: true, completion: nil)
            
            var request = URLRequest(url: URL(string: AppDelegate.projectsURL)!)
            request.httpBody = try? JSONSerialization.data(withJSONObject: ["project" : ["name": vc.textFields![0].text as? AnyObject, "color": -13508189 as AnyObject]], options: .prettyPrinted)
            request.addValue("application/json", forHTTPHeaderField: "Content-type")
            request.addValue(UserDefaults.standard.string(forKey: "apiKey")!, forHTTPHeaderField: "X-Qer-Authorization")
            request.httpMethod="POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request, completionHandler: { (data, response, optError) in
                DispatchQueue.main.async{
                    if let error = optError
                    {
                        UIAlertView(title: "Ruh roh", message: error.localizedDescription + "\nMaybe check your internet?", delegate: nil, cancelButtonTitle: ":(").show()
                    }
                    var request = URLRequest(url: URL(string: AppDelegate.projectsURL)!)
                    request.addValue("application/json", forHTTPHeaderField: "Content-type")
                    request.addValue(UserDefaults.standard.string(forKey: "apiKey")!, forHTTPHeaderField: "X-Qer-Authorization")
                    request.addValue("application/json", forHTTPHeaderField: "Accept")
                    
                    URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request, completionHandler: { (data, response, optError) in
                        DispatchQueue.main.async {
                            if let error = optError {
                                UIAlertView(title: "Ruh roh", message: error.localizedDescription + "\nMaybe check your internet?", delegate: nil, cancelButtonTitle: ":(").show()
                            }
                            
                            if let jsonData = data {
                                self.projects = try! JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [[String : AnyObject?]]
                                self.tableView.reloadData()
                                //                        }catch let jsonError as NSError {
                                //
                                //                        }
                            }
                        }
                    }).resume()
                }
            }).resume()
        }))
        
        vc.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            vc.dismiss(animated: true, completion: nil)
        })
        
        vc.addTextField { (textfield) in
            textfield.placeholder = "Name"
        }
        
        present(vc, animated: true, completion: nil)
    }
    
}

//MARK: - TableView Delegates and Methods

extension ProjectsViewController: UITableViewDelegate {}

extension ProjectsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "project", for: indexPath)
        
        if let projects = projects, let projectName = projects[indexPath.row]["name"] as? String {
            cell.textLabel?.text = projectName
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let projects = projects {
            return projects.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let projects = projects {
            selectedProject = projects[indexPath.row]
            tableView.deselectRow(at: indexPath, animated: true)
            
            // TODO: Code for moving onto the next View when it is up
            // performSegue(withIdentifier: "viewproject", sender: self)
        }
    }
    
}
