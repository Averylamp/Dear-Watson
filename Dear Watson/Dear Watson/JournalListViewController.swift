//
//  JournalListViewController.swift
//  Dear Watson
//
//  Created by whisk on 7/20/17.
//  Copyright © 2017 Avery Lamp. All rights reserved.
//

import UIKit

class JournalListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var journalEntries = [[String: Any]] ()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    @IBAction func createEntryClicked(_ sender: Any) {
        if let journalInputVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JournalInputVC") as? JournalInputViewController{
            self.navigationController?.pushViewController(journalInputVC, animated: true)
            
        }
        
    }
}

extension JournalListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return journalEntries.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let journalEntryCell = tableView.dequeueReusableCell(withIdentifier: "JournalEntryCell") as? JournalEntryTableViewCell{
            
            
            
         return journalEntryCell
        }
        else{
            return UITableViewCell()
        }
    }
}
