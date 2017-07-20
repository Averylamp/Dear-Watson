//
//  InfoViewController.swift
//  WhiskBot
//
//  Created by whisk on 6/26/17.
//  Copyright © 2017 Avery Lamp. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet var titleLabels: [UILabel]!
    
    @IBOutlet var textLabels: [UILabel]!
    
    
    let titleText = ["Dear Watson","Emotional Analysis","Self Awareness","Extra Info"]
    let infoText = ["Dear Watson is your very own personal journal taking solution.  With each journal entry, Watson analyzes it in order to give you information about yourself, your emotions, and the highlights of your day.  \n\n","Every journal post you make in Dear Watson is analyzed by using the Watson ___________ API.  The analysis of what you say is broken up into _ emotions: happy, sad, cheerful, emotion, emotion, and emotion.  Each ","Even more interesting information about WhiskBot","Last bits of interesting information about Whiskbot"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        backgroundImage.frame = CGRect(x: 0, y: 0, width: self.view.frame.width * 2, height: self.view.frame.height)
        backgroundImage.frame.origin.x = 0
        setupTitles()
        
        EmotionAnalyzer.sharedInstance.keywordsFrom(text: "Dear Watson is your very own personal journal taking solution.  With each journal entry, Watson analyzes it in order to give you information about yourself, your emotions, and the highlights of your day. ", numberOfKeywords: 5) { (response) in
            print(response)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        backgroundImage.frame = CGRect(x: 0, y: 0, width: self.view.frame.width * 2, height: self.view.frame.height)
        backgroundImage.frame.origin.x = 0
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        backgroundImage.frame = CGRect(x: 0, y: 0, width: size.width * 2, height: size.height)
        backgroundImage.frame.origin.x = 0
    }
    
    func setupTitles(){
        for titleLabel in titleLabels{
            titleLabel.text = titleText[titleLabel.tag]
        }
        for textLabel in textLabels{
            textLabel.text = infoText[textLabel.tag]
        }
    }
    
    @IBAction func continueButtonClicked(_ sender: Any) {
        if let journalListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JournalListVC") as? JournalListViewController, let navVC = self.navigationController{
            navVC.setViewControllers([journalListVC], animated: true)
        }
        
    }
}

extension InfoViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let positionPercent = scrollView.contentOffset.x / ( scrollView.contentSize.width - self.view.frame.width)
//        backgroundImage.center.x = self.view.center.x + self.view.frame.width - self.view.frame.width * positionPercent
        backgroundImage.frame.origin.x = -positionPercent * self.view.frame.width
    }
    
}
