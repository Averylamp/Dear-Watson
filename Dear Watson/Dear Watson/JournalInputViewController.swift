//
//  JournalInputViewController.swift
//  Dear Watson
//
//  Created by whisk on 7/20/17.
//  Copyright © 2017 Avery Lamp. All rights reserved.
//

import UIKit

let joyfulFace = "😀"
let sadFace = "😢"
let disgustedFace = "🙄"
let fearfulFace = "😨"
let angryFace = "😡"
let smileyFace = "😁"

class JournalInputViewController: UIViewController {
    
    var appleSpeechAnalyzer =  AppleSpeechController()
    var speechActive = false
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var faceLabel: UILabel!
    
    //sadness, joy,fear, anger, disgust
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appleSpeechAnalyzer = AppleSpeechController()
        appleSpeechAnalyzer.delegate = self
        appleSpeechAnalyzer.setupRecognizer()
        
        faceLabel.growAndShrink(duration: 5.0, times: 10)
        faceLabel.shake(duration: 5.0)
        faceLabel.rotate(duration: 5.0, times: 10)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func nextQuestionClicked(_ sender: Any) {
    }
    
    let buttonTransitionAnimationTime = 0.5
    
}

extension JournalInputViewController: AppleSpeechFeedbackProtocall{
    
    func toggleAppleSTT(){
        if appleSpeechAnalyzer.isRecording(){
            stopAppleSTT()
        }else{
            startAppleSTT()
        }
    }
    

    func stopAppleSTT(){
        if appleSpeechAnalyzer.isRecording(){
            appleSpeechAnalyzer.recordButtonTapped()
            UIView.transition(with: recordButton, duration: buttonTransitionAnimationTime,options: .transitionCrossDissolve,animations: {
                self.recordButton.setImage(#imageLiteral(resourceName: "MicButton"), for: .normal)
            },completion: nil)
            speechActive = false
        }
    }
    
    func startAppleSTT(){
        if appleSpeechAnalyzer.isRecording() == false{
            appleSpeechAnalyzer.recordButtonTapped()
            UIView.transition(with: recordButton, duration: buttonTransitionAnimationTime,options: .transitionCrossDissolve,animations: {
                self.recordButton.setImage(#imageLiteral(resourceName: "stopButton"), for: .normal)
            },completion: nil)
            speechActive = true
        }
    }
    
    func finalAppleRecognitionRecieved(phrase: String) {
    
    }
    
    func partialAppleRecognitionRecieved(phrase: String) {
        
    }
    
    func errorAppleRecieved(error: String) {
        print("ERROR RECORDING \(error)")
    }
    
    
    
}


extension UIView {
    func shake(duration: Double) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.duration = duration
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        
        layer.add(animation, forKey: "shake")
    }
    
    func growAndShrink(duration: Double, times: Int) {
        let xAnimation = CAKeyframeAnimation(keyPath: "transform.scale.x")
        xAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        xAnimation.duration = duration
        var values:[Double] = [Double]()
        for i in 0..<times{
            values.append(1.02 + Double(arc4random_uniform(10) + 5) / 100.0)
            values.append(0.98 - Double(arc4random_uniform(10) + 5) / 100.0)
        }
        values.append(1.0)
        xAnimation.values = values
        layer.add(xAnimation, forKey: "scale_x")
        let yAnimation = CAKeyframeAnimation(keyPath: "transform.scale.y")
        yAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        yAnimation.duration = duration
        yAnimation.values = values
        layer.add(yAnimation, forKey: "scale_y")
        
    }
    
    func rotate(duration:Double, times: Int){
        let rotationAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.duration = duration
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        rotationAnimation.isAdditive = true
        var values: [Double] = [Double]()
        for i in 0..<times{
            values.append(M_PI_4 / 10)
            values.append(-M_PI_4 / 10)
        }
        values.append(0)
        rotationAnimation.values = values
        layer.add(rotationAnimation, forKey: "rotate")
    }
}
