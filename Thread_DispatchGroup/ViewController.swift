//
//  ViewController.swift
//  Thread_DispatchGroup
//
//  Created by Ahn on 2020/05/23.
//  Copyright © 2020 ozofweird. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let groupA = ["user 1", "user 2"]
    let groupB = ["user 3", "user 4"]
    let groupC = ["user 5", "user 6"]
    
    var users = [String]()
    
    let dispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.dataSource = self
    }

    func run(after seconds: Int, completion: @escaping () -> Void) {
        let deadline = DispatchTime.now() + .seconds(seconds)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            completion()
        }
    }
    
    func getGroupA() {
        dispatchGroup.enter()
        run(after: 2) {
            print("got A")
            self.users.append(contentsOf: self.groupA)
             self.dispatchGroup.leave()
        }
    }
    
    func getGroupB() {
        dispatchGroup.enter()
        run(after: 4) {
            print("got B")
            self.users.append(contentsOf: self.groupB)
            self.dispatchGroup.leave()
        }
    }
    
    func getGroupC() {
        dispatchGroup.enter()
        run(after: 6) {
            print("got C")
            self.users.append(contentsOf: self.groupC)
            self.dispatchGroup.leave()
        }
    }
    
    func displayUsers() {
        print("reloading data")
        self.tableView.reloadData()
    }
    
    @IBAction func downloadBtn(_ sender: Any) {
        print("downloading")
        getGroupA()
        getGroupB()
        getGroupC()
        
        dispatchGroup.notify(queue: .main) {
            self.displayUsers()
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.users[indexPath.row]
        return cell
    }
    
}
