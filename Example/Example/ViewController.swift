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

    @IBOutlet weak var keyboardView: GLNPianoView!
    @IBOutlet weak var keyStepper: UIStepper!
    @IBOutlet weak var keyNumberLabel: UILabel!
    @IBOutlet weak var octaveStepper: UIStepper!
    @IBOutlet weak var octaveLabel: UILabel!
    var octave: UInt8 = 60
    let audioEngine = AudioEngine()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardView.delegate = self;
        keyStepper.value = Double(keyboardView.totalNumKeys)
        keyNumberLabel.text = String(keyStepper.value)
        octaveLabel.text = String(octaveStepper.value)
        
        audioEngine.start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func pianoKeyDown(_ keyNumber: UInt8) {
        audioEngine.sampler.startNote(UInt8(octave + keyNumber), withVelocity: 64, onChannel: 0)
    }
    
    func pianoKeyUp(_ keyNumber: UInt8) {
        audioEngine.sampler.stopNote(UInt8(octave + keyNumber), onChannel: 0)
    }
    
    @IBAction func keyStepperTapped(_ sender: UIStepper) {
        keyboardView.setNumberOfKeys(count: Int(sender.value))
        keyNumberLabel.text = String(keyStepper.value)
    }
    
    @IBAction func octaveStepperTapped(_ sender: UIStepper) {
        octave = UInt8(sender.value)
        octaveLabel.text = String(octave)
    }
    
}






