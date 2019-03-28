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

    @IBOutlet weak var fascia: UIView!
    @IBOutlet weak var keyboard: GLNPianoView!
    @IBOutlet weak var keyNumberStepper: UIStepper!
    @IBOutlet weak var keyNumberLabel: UILabel!
    @IBOutlet weak var octaveStepper: UIStepper!
    @IBOutlet weak var octaveLabel: UILabel!
    private let audioEngine = AudioEngine()

    override func viewDidLoad() {
        super.viewDidLoad()
        keyboard.delegate = self
        keyNumberStepper.value = Double(keyboard.numberOfKeys)
        keyNumberLabel.text = String(keyNumberStepper.value)
        octaveLabel.text = String(octaveStepper.value)
        audioEngine.start()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let layer = CAGradientLayer()
        layer.frame = fascia.bounds
        layer.colors = [UIColor.black.cgColor, UIColor.darkGray.cgColor, UIColor.black.cgColor]
        layer.startPoint = CGPoint(x: 0.0, y: 0.80)
        layer.endPoint = CGPoint(x: 0.0, y: 1.0)
        fascia.layer.insertSublayer(layer, at: 0)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func pianoKeyDown(_ keyNumber: UInt8) {
        audioEngine.sampler.startNote((keyboard.octave + keyNumber), withVelocity: 64, onChannel: 0)
    }

    func pianoKeyUp(_ keyNumber: UInt8) {
        audioEngine.sampler.stopNote((keyboard.octave + keyNumber), onChannel: 0)
    }

    @IBAction func showNotes(_: Any) {
        keyboard.toggleShowNotes()
    }

    @IBAction func keyNumberStepperTapped(_ sender: UIStepper) {
        keyboard.numberOfKeys = Int(sender.value)
        keyNumberLabel.text = String(keyNumberStepper.value)
    }

    @IBAction func octaveStepperTapped(_ sender: UIStepper) {
        keyboard.octave = UInt8(sender.value)
        octaveLabel.text = String(keyboard.octave)
    }
}

