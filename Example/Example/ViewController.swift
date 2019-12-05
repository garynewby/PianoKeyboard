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
        keyNumberStepper.layer.cornerRadius = 8.0
        keyNumberStepper.layer.masksToBounds = true
        octaveStepper.layer.cornerRadius = 8.0
        octaveStepper.layer.masksToBounds = true
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
        
        // Auto highlighting
        let chordDemo = false
        if chordDemo {
            autoHighlight(score: [["C4", "Eb4", "G4"],
                                  ["D4", "F4", "A4"],
                                  ["E4", "F#4", "B4"],
                                  ["C4", "E4", "G4"]
                ], position: 0, loop: true, tempo: 130.0, play: true)
        } else {
            autoHighlight(score: [[Note.name(of: 60), Note.name(of: 63), Note.name(of: 67)],
                                  [Note.name(of: 62)],
                                  [Note.name(of: 63)],
                                  [Note.name(of: 65)],
                                  [Note.name(of: 63)],
                                  [Note.name(of: 62)]
                ], position: 0, loop: true, tempo: 130.0, play: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func pianoKeyDown(_ keyNumber: Int) {
        audioEngine.sampler.startNote(UInt8(keyboard.octave + keyNumber), withVelocity: 64, onChannel: 0)
    }

    func pianoKeyUp(_ keyNumber: Int) {
        audioEngine.sampler.stopNote(UInt8(keyboard.octave + keyNumber), onChannel: 0)
    }
    
    func autoHighlight(score: [[String]], position: Int, loop: Bool, tempo: Double, play: Bool) {
        let playingColor = UIColor.init(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.35)
        let highlightColor = UIColor.init(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.15)
        
        // Collect all included notes in score
        var highlightKeys: [Int: UIColor] = [:]
        for step in score {
            for noteString in step {
                highlightKeys[Note.number(of: noteString)!] = highlightColor
            }
        }
        for noteString in score[position] {
            highlightKeys[Note.number(of: noteString)!] = playingColor
        }
        
        keyboard.highlightKeys(highlightKeys, play: play)
        let delay = 60.0/tempo
        let nextPosition = position + 1
        if nextPosition < score.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                self?.autoHighlight(score: score, position: nextPosition, loop: loop, tempo: tempo, play: play)
            }
        } else {
            if loop {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                    self?.autoHighlight(score: score, position: 0, loop: loop, tempo: tempo, play: play)
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                    self?.keyboard.reset()
                }
            }
        }
    }

    @IBAction func showNotes(_: Any) {
        keyboard.toggleShowNotes()
    }

    @IBAction func keyNumberStepperTapped(_ sender: UIStepper) {
        keyboard.numberOfKeys = Int(sender.value)
        keyNumberLabel.text = String(keyNumberStepper.value)
    }

    @IBAction func octaveStepperTapped(_ sender: UIStepper) {
        keyboard.octave = Int(sender.value)
        octaveLabel.text = String(keyboard.octave)
    }
}

