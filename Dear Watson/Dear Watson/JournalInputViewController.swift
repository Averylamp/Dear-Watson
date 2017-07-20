//
//  JournalInputViewController.swift
//  Dear Watson
//
//  Created by whisk on 7/20/17.
//  Copyright © 2017 Avery Lamp. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import LTMorphingLabel

let journalEntryKey = "JournalEntryKey"
let joyfulFace = "😀"
let sadFace = "😢"
let disgustedFace = "🙄"
let fearfulFace = "😨"
let angryFace = "😡"
let smileyFace = "😁"

class JournalInputViewController: UIViewController {
    
    var synth = AVSpeechSynthesizer()
    
    @IBOutlet weak var responseTextView: UITextView!
    var appleSpeechAnalyzer =  AppleSpeechController()
    var speechActive = false
    
    @IBOutlet weak var questionLabel: LTMorphingLabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var faceLabel: UILabel!
    
    //sadness, joy,fear, anger, disgust
    
    var temporaryText = ""
    var fullText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appleSpeechAnalyzer = AppleSpeechController()
        appleSpeechAnalyzer.delegate = self
        appleSpeechAnalyzer.setupRecognizer()
        questionLabel.text = ""
        questionLabel.morphingEffect = .fall
        questionLabel.morphingDuration = 2.0
        questionLabel.morphingCharacterDelay = 0.05
        

        self.delay(delay: 1.0) {
            let question = PhraseGeneration.sharedInstance.getGreeting()
            self.askQuestion(question: question)
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func saveInformation(){
        let defaults = UserDefaults.standard
        var fullAllEntries = [[String:Any]]()
        if let allEntries = defaults.array(forKey: journalEntryKey), let formattedAllEntries = allEntries as? [[String:Any]] {
            fullAllEntries = formattedAllEntries
        }
        var journalEntry = [String:Any]()
        journalEntry["journalTitle"] = "Journal Entry 1"
        journalEntry["date"] = Date()
        journalEntry["fullText"] = self.responseTextView.text
        journalEntry["keywords"] = []
        journalEntry["emotions"] = []
        
        
        fullAllEntries.append(journalEntry)
        defaults.set(fullAllEntries, forKey: journalEntryKey)
    }

    
    
    @IBAction func nextQuestionClicked(_ sender: Any) {
        self.askQuestion(question: "Cool.  Anything else new today?")
        self.delay(delay: 0.3) {
            self.responseTextView.text = self.responseTextView.text + "\n\n"
            self.fullText = self.responseTextView.text
        }
    }
    
    @IBAction func recordButtonClicked(_ sender: Any) {
        self.toggleAppleSTT()
    }
    
    func askQuestion(question:String){
        self.stopAppleSTT()
        speakResponse(text: question)
        questionLabel.text = question
        delay(delay: 1.0) {
            self.startAppleSTT()
        }
    }
    
    let buttonTransitionAnimationTime = 0.5
    func speakResponse(text:String){
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        utterance.volume = 1.0
        self.synth.speak(utterance)
        faceLabel.growAndShrink(duration: 3.0, times: 6)
        faceLabel.shake(duration: 3.0)
        faceLabel.rotate(duration: 3.0, times: 10)
    }
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
        temporaryText = ""
        self.responseTextView.text = fullText + phrase + ".  "
        fullText = self.responseTextView.text
        DispatchQueue.main.async {
            UIView.transition(with: self.recordButton, duration: self.buttonTransitionAnimationTime,options: .transitionCrossDissolve,animations: {
                self.recordButton.setImage(#imageLiteral(resourceName: "MicButton"), for: .normal)
            },completion: nil)
        }
    }
    
    func partialAppleRecognitionRecieved(phrase: String) {
        temporaryText = phrase
        self.responseTextView.text = fullText + temporaryText
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

    func bounce(duration: Double, times: Int) {
        let yAnimation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        yAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        yAnimation.duration = duration
        var values: [Double] = [Double]()
        for i in 0..<times{
            values.append(10)
            values.append(-10)
        }
        yAnimation.values = values
        layer.add(yAnimation, forKey: "bounce")
    }

    func spin(duration:Double, times:Int){
        let yAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.x")
        yAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        yAnimation.duration = duration
        var values: [Double] = [Double]()
        for i in 0..<times{
            values.append(10)
           values.append(-2)
        }
        yAnimation.values = values
        layer.add(yAnimation, forKey: "rotate_x")
    }
}
