//
//  ViewController.swift
//  Example
//
//  Created by gary on 17/05/2016.
//  Copyright © 2016 Gary Newby. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, GLNPianoViewDelegate {
    
    @IBOutlet weak var fasciaView: UIView!
    @IBOutlet weak var keyboardView: GLNPianoView!
    @IBOutlet weak var keyStepper: UIStepper!
    @IBOutlet weak var keyNumberLabel: UILabel!
    @IBOutlet weak var octaveStepper: UIStepper!
    @IBOutlet weak var octaveLabel: UILabel!
    private let audioEngine = AudioEngine()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layer = CAGradientLayer()
        layer.frame = fasciaView.bounds
        layer.colors = [UIColor.black.cgColor, UIColor.darkGray.cgColor, UIColor.black.cgColor,]
        layer.startPoint = CGPoint(x: 0.0, y: 0.80)
        layer.endPoint = CGPoint(x: 0.0, y: 1.0)
        fasciaView.layer.insertSublayer(layer, at: 0)
      
        keyboardView.octave = 60
        keyboardView.delegate = self;
        keyStepper.value = Double(keyboardView.totalNumKeys)
        keyNumberLabel.text = String(keyStepper.value)
        octaveLabel.text = String(octaveStepper.value)
        audioEngine.start()
    }
    
    func pianoKeyDown(_ keyNumber: UInt8) {
        audioEngine.sampler.startNote(keyNumber, withVelocity: 64, onChannel: 0)
    }
    
    func pianoKeyUp(_ keyNumber: UInt8) {
        audioEngine.sampler.stopNote(keyNumber, onChannel: 0)
    }
    
    @IBAction func showNotes(_ sender: UISwitch) {
        keyboardView.showNotes = sender.isOn
    }
    
    @IBAction func keyStepperTapped(_ sender: UIStepper) {
        keyboardView.totalNumKeys = Int(sender.value)
        keyNumberLabel.text = String(keyStepper.value)
    }
    
    @IBAction func octaveStepperTapped(_ sender: UIStepper) {
        keyboardView.octave = Int(sender.value)
        octaveLabel.text = String(keyboardView.octave)
    }
    
}
