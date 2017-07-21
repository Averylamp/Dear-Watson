//
//  SingleEntryViewController.swift
//  Dear Watson
//
//  Created by Avery Lamp on 7/21/17.
//  Copyright © 2017 Avery Lamp. All rights reserved.
//

import UIKit

class SingleEntryViewController: UIViewController {

    @IBOutlet weak var emotionsLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var fullTextLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func setEmotionsLabel(emotions: [[Any]]){
        var text = "Emotion : "
        var count = 0
        let sortedEmotions = emotions.sorted { (first, second) -> Bool in
            return (first[1] as! Double) > (second[1] as! Double)
        }
        for item in sortedEmotions {
            let emotion = item[0] as! String
            let emotionValue = item[1] as! Double * 100
            switch emotion {
            case Emotions.Joy.emotionToString():
                text += "\(joyfulFace) \(String(format: "%.1f", emotionValue)), "
            case Emotions.Fear.emotionToString():
                text += "\(fearfulFace) \(String(format: "%.1f", emotionValue)), "
            case Emotions.Anger.emotionToString():
                text += "\(angryFace) \(String(format: "%.1f", emotionValue)), "
            case Emotions.Disgust.emotionToString():
                text += "\(disgustedFace) \(String(format: "%.1f", emotionValue)), "
            case Emotions.Sadness.emotionToString():
                text += "\(sadFace) \(String(format: "%.1f", emotionValue)), "
            default:
                print("Case not found")
            }
            count += 1
        }
        self.emotionsLabel.text = text
    }

}
