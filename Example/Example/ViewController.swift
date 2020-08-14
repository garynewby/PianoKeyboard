//
//  ViewController.swift
//  Example
//
//  Created by gary on 17/05/2016.
//  Copyright © 2016 Gary Newby. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, PianoKeyboardDelegate {
    @IBOutlet private var fascia: FasciaView!
    @IBOutlet private var keyboard: PianoKeyboard!
    @IBOutlet private var keyNumberStepper: UIStepper!
    @IBOutlet private var keyNumberLabel: UILabel!
    @IBOutlet private var octaveStepper: UIStepper!
    @IBOutlet private var octaveLabel: UILabel!
    @IBOutlet private var showNotesSwitch: UISwitch!
    @IBOutlet private var latchSwitch: UISwitch!

    private let audioEngine = AudioEngine()
    private var demo: Demo?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        demo = Demo(keyboard: keyboard)
        keyboard.delegate = self

        keyNumberLabel.text = String(Int(keyNumberStepper.value))
        keyNumberLabel.accessibilityIdentifier = "keyNumberLabel"

        keyNumberStepper.layer.cornerRadius = 8.0
        keyNumberStepper.layer.masksToBounds = true
        keyNumberStepper.value = Double(keyboard.numberOfKeys)
        keyNumberStepper.accessibilityIdentifier = "keyNumberStepper"
        keyNumberStepper.isAccessibilityElement = true

        octaveLabel.text = String(Int(octaveStepper.value))
        octaveLabel.accessibilityIdentifier = "octaveLabel"

        octaveStepper.layer.cornerRadius = 8.0
        octaveStepper.layer.masksToBounds = true
        octaveStepper.accessibilityIdentifier = "octaveStepper"
        octaveStepper.isAccessibilityElement = true

        showNotesSwitch.subviews[0].subviews[0].backgroundColor = .gray
        showNotesSwitch.accessibilityIdentifier = "showNotesSwitch"
        showNotesSwitch.isAccessibilityElement = true

        latchSwitch.subviews[0].subviews[0].backgroundColor = .gray
        latchSwitch.accessibilityIdentifier = "latchSwitch"
        latchSwitch.isAccessibilityElement = true

        audioEngine.start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        demo?.notes()
        //demo?.chords()
    }

    //MARK: - Settings

    @IBAction func latchTapped(_ sender: Any) {
        keyboard.toggleLatch()
    }

    @IBAction func showNotesTapped(_: Any) {
        keyboard.toggleShowNotes()
    }

    @IBAction func keyNumberStepperTapped(_ sender: UIStepper) {
        keyboard.numberOfKeys = Int(sender.value)
        keyNumberLabel.text = String(Int(keyNumberStepper.value))
    }

    @IBAction func octaveStepperTapped(_ sender: UIStepper) {
        keyboard.octave = Int(sender.value)
        octaveLabel.text = String(Int(keyboard.octave))
    }
}

//MARK: - PianoKeyboardDelegate

extension ViewController {
    func pianoKeyDown(_ keyNumber: Int) {
        audioEngine.sampler.startNote(UInt8(keyboard.octave + keyNumber), withVelocity: 64, onChannel: 0)
    }

    func pianoKeyUp(_ keyNumber: Int) {
        audioEngine.sampler.stopNote(UInt8(keyboard.octave + keyNumber), onChannel: 0)
    }
}
