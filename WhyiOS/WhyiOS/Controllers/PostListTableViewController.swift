//
//  PostListTableViewController.swift
//  WhyiOS
//
//  Created by Markus Varner on 9/6/18.
//  Copyright © 2018 Markus Varner. All rights reserved.
//

import UIKit

class PostListTableViewController: UITableViewController {
    
     //MARK: - Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        load()
    }
    //MARK: - Actions
    
    func load() {
        PostController.shared.fetchPost { (success) in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        presentAlert()
    }
    @IBAction func refreshButtonTapped(_ sender: UIBarButtonItem) {
        load()
    }
    
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return PostController.shared.posts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell
        let post = PostController.shared.posts[indexPath.row]
        
        //this is where the post cells landing pad comes into play
        cell?.post = post
        
        
        return cell ?? UITableViewCell()
    }
    
    func presentAlert() {
        let reasonAlert = UIAlertController(title: "Why iOS?", message: "List your name, cohort, and reason for choosing iOS.", preferredStyle: .alert)
        
        //TextFields Setup
        reasonAlert.addTextField { (nameTextFieldForReason) in
            nameTextFieldForReason.placeholder = "Name"
        }
        reasonAlert.addTextField { (cohortTextFieldForReason) in
            cohortTextFieldForReason.placeholder = "Cohort"
        }
        reasonAlert.addTextField { (reasonTextFieldForReason) in
            reasonTextFieldForReason.placeholder = "Reason"
        }
        //Save Action Setup
        let saveAction = UIAlertAction(title: "Save", style: .default) { (_) in
            
            guard let nameText = reasonAlert.textFields?[0].text else { return }
            //there has to be a cohort text
            let cohortText = reasonAlert.textFields?[1].text ?? ""
            guard let reasonText = reasonAlert.textFields?[2].text else { return }
            
            PostController.shared.putPost(reason: reasonText, name: nameText, cohort: cohortText, completion: { (success) in
                if success {
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                }
            })
        }
        
        //Cancel Action Setup
        let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        reasonAlert.addAction(saveAction)
        reasonAlert.addAction(dismissAction)
        
        present(reasonAlert, animated: true)
        
    }
  
    
} //END
