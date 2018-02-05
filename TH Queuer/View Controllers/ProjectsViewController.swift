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

    var selectedProject = [String : AnyObject?]()
    var projects: [[String : AnyObject?]]? {
        didSet {
            self.tableView.reloadData()
        }
    }
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
            guard let getData = data else {
                ErrorMessage.manager.presentErrorMessage(.noData, self)
                return
            }

            do {
                let serializedData = try JSONSerialization.jsonObject(with: getData, options: .allowFragments) as! [[String : AnyObject?]]
                self.projects = serializedData
            }
            catch {
                ErrorMessage.manager.presentErrorMessage(.cannotParseJSON(rawError: error), self)
            }

        }

        let errorHandling = { (error: Error?) in
            if let error = error {
                ErrorMessage.manager.presentErrorMessage(AppError.other(rawError: error), self)
            }
        }

        ProjectHelper.manager.makeRequest(completionHandler: completion,
                                          errorHandler: errorHandling)
    }
    
    func addRightBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForProject))
    }

    @objc func promptForProject() {
        let vc = UIAlertController(title: "Project name", message: nil, preferredStyle: .alert)

        vc.addTextField { (textfield) in
            textfield.placeholder = "Name"
        }
        
        vc.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            vc.dismiss(animated: true, completion: nil)

            if let textFields = vc.textFields, let projectName = textFields[0].text {
                let completion = { (data: Data?) in
                    guard data != nil else { return }

                    let completionCeption = { (data: Data?) in
                        guard let getData = data else { return }

                        let serializedData = try? JSONSerialization.jsonObject(with: getData, options: .allowFragments) as? [[String : AnyObject?]]

                        guard serializedData != nil else { return }

                        self.projects = serializedData!

                    }

                    let errorCeption = { (error: Error?) in
                        if let error = error {
                            ErrorMessage.manager.presentErrorMessage(.other(rawError: error), self)
                        }
                    }

                    ProjectHelper.manager.makeRequest(completionHandler: completionCeption,
                                                      errorHandler: errorCeption)

                }

                let errorHandling = { (error: Error?) in
                    if let error = error {
                        ErrorMessage.manager.presentErrorMessage(.other(rawError: error), self)
                    }
                }

                ProjectHelper.manager.createProject(projectName,
                                                    completionHandler: completion,
                                                    errorHandler: errorHandling)
            }
        }))

        vc.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            vc.dismiss(animated: true, completion: nil)
        })

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
