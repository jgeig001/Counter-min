//
//  ViewController.swift
//  Counter
//
//  Created by Jonathan Geiger on 30.03.19.
//  Copyright © 2019 JonathanGeiger. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var perTimeLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var plusButtonLabel: UIButton!
    @IBOutlet weak var minusButtonLabel: UIButton!
    @IBOutlet weak var playPauseButtonLabel: UIButton!
    
    var counter = 0
    var time_sec = 0
    var timerObj:Timer!
    
    @IBAction func plusButton(_ sender: UIButton) {
        if (timerObj == nil) || timerObj.isValid == false {
            timerObj = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.timeUpdate), userInfo: nil, repeats: true)
        }
        counter += 1
        updateView(counter: counter, time_sec: time_sec)
        playPauseButton.setImage(UIImage(named: "pause.png"), for: .normal)
        popUpAnimation(of: plusButtonLabel, to: 1.05)
        popUpAnimation(of: counterLabel, to: 1.1)
    }
    
    @IBAction func minusButton(_ sender: UIButton) {
        counter -= 1
        if counter < 0 {
            counter = 0
        }
        updateView(counter: counter, time_sec: time_sec)
        popUpAnimation(of: minusButtonLabel, to: 0.95)
        popUpAnimation(of: counterLabel, to: 0.9)
    }
    
    func popUpAnimation (of label: UIView, to factor: Double) {
        UIView.animate(withDuration: 0.1, delay: 0.0,
                       options: [.allowUserInteraction],
                       animations: { label.transform = CGAffineTransform(scaleX: CGFloat(factor), y: CGFloat(factor)) },
                       completion: nil)
        UIView.animate(withDuration: 0.1, delay: 0.1,
                       options: [.allowUserInteraction],
                       animations: { label.transform = CGAffineTransform(scaleX: 1.0, y: 1.0) },
                       completion: nil)
    }
    
    
    
    @IBAction func pressedPlayPauseButton(_ sender: UIButton) {
        // counting-processs exists and is running -> stop timer & set buttonImage to [PLAY]
        if (timerObj != nil) && timerObj.isValid {
            timerObj.invalidate()
            playPauseButton.setImage(UIImage(named: "play.png"), for: .normal)
            popUpAnimation(of: playPauseButtonLabel, to: 1.1)
        } else {
            // counting-processs is paused or nil -> start timer & set buttonImage to [PAUSE]
            timerObj = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.timeUpdate), userInfo: nil, repeats: true)
            playPauseButton.setImage(UIImage(named: "pause.png"), for: .normal)
            popUpAnimation(of: playPauseButtonLabel, to: 1.1)
        }
    }
    
    @IBAction func resetButton(_ sender: UIButton) {
        // no alert, if already reseted
        if time_sec == 0 {
            return
        }
        // confirm reset
        let alert = UIAlertController(title: "RESET", message: "Do you really want to reset the counter?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            if self.timerObj != nil {
                self.timerObj.invalidate()
            }
            self.time_sec = 0
            self.counter = 0
            self.updateView(counter: self.counter, time_sec: self.time_sec)
            self.playPauseButton.setImage(UIImage(named: "play.png"), for: .normal)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func updateView(counter c:Int, time_sec t:Int) {
        counterLabel.text = String(c)
        timeLabel.text = secToTimeString(sec: t)
        if t != 0 {
            let minuteFloat:Float = Float(time_sec) / 60.0
            perTimeLabel.text = String(format:"%.02f/min" ,Float(counter)/minuteFloat)
        } else {
            perTimeLabel.text = String(format:"%.02f/min" , 0)
        }
    }
    
    @objc func timeUpdate () {
        time_sec += 1
        updateView(counter: counter, time_sec: time_sec)
    }
    
    func secToTimeString (sec :Int) -> String {
        let hours = sec / 3600
        let minutes = (sec % 3600) / 60
        let seconds = (sec % 3600) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UserDefaults
        /*NotificationCenter.default.addObserver(self, selector: #selector(saveUserDefaults), name: UIApplication.willTerminateNotification, object: nil)*/
        NotificationCenter.default.addObserver(self, selector: #selector(saveUserDefaults), name: UIApplication.willResignActiveNotification, object: nil)
        let defaults = UserDefaults.standard
        counter = defaults.integer(forKey: "counter")
        time_sec = defaults.integer(forKey: "time_sec")
        
        // init values in view
        updateView(counter: counter, time_sec: time_sec)
        
        // Backgroundgradientcolor
        let color1 = UIColor(red: 0.039215686, green: 1.0, blue: 0.650980392, alpha: 1.0)
        let color2 = UIColor(red: 0.109803921, green: 0.160784313, blue: 0.549019607, alpha: 1.0)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x:1.0, y:1.0)
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @objc func saveUserDefaults() {
        print("--- saveUserDefaults() ---")
        let defaults = UserDefaults.standard
        defaults.set(counter, forKey: "counter")
        defaults.set(time_sec, forKey: "time_sec")
    }
    
}


