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
        
        self.loadJournalEntries()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadJournalEntries()
    }
    
    func loadJournalEntries(){
        if let entries = UserDefaults.standard.array(forKey: journalEntryKeys.journalStoreKey) as? [[String: Any]]{
            self.journalEntries = entries
            print("Entries loaded - \(entries.count)")
            self.tableView.reloadData()
            self.tableView.reloadRows(at: self.tableView.indexPathsForVisibleRows!, with: .automatic)
        }
        
    }
    
    @IBAction func createEntryClicked(_ sender: Any) {
        if let journalInputVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JournalInputVC") as? JournalInputViewController{
            self.navigationController?.pushViewController(journalInputVC, animated: true)
            
        }
        
    }
    
    
    @IBAction func infoButtonClicked(_ sender: Any) {
        
        let infoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PersonInfoVC")
            self.navigationController?.pushViewController(infoVC, animated: true)
        
        for journalEntry in journalEntries{
            if let emotion = journalEntry[journalEntryKeys.emotionKey] as? [[Any]] {
                print(emotion)
            }
        }
    
    }
    
    
}

extension JournalListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return journalEntries.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let journalEntryCell = tableView.dequeueReusableCell(withIdentifier: "JournalEntryCell") as? JournalEntryTableViewCell{
            let journalEntryData = self.journalEntries[indexPath.row]
            if let journalDate = journalEntryData[journalEntryKeys.dateKey] as? String{
                journalEntryCell.journalDateLabel.text = "Date: \(journalDate)"
            }
            journalEntryCell.journalTitleLabel.text = journalEntryData[journalEntryKeys.journalTitleKey] as? String
            var fullKeywords = ""
            let journalKeywords = journalEntryData[journalEntryKeys.keywordsKey] as? [String]
            journalKeywords?.forEach{
                fullKeywords += "\($0), "
            }
            journalEntryCell.keywordsLabel.text = "Keywords: \(fullKeywords)"
            if let emotions = journalEntryData[journalEntryKeys.emotionKey] as? [[Any]]{
                journalEntryCell.setEmotionsLabel(emotions: emotions)
            }
         return journalEntryCell
        }
        else{
            return UITableViewCell()
        }
    }
}
