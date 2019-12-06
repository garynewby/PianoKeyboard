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
    var sequence: Sequence?

    override func viewDidLoad() {
        super.viewDidLoad()
        keyboard.delegate = self

        // Customm labels
        keyboard.labels[60] = "Do"
        keyboard.labels[62] = "Re"
        keyboard.labels[64] = "Me"

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
        
        // Auto highlighting/playing examples
        noteDemo()
        //chordDemo()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboard.highlightKey(noteNumber: 72, color: UIColor.red.withAlphaComponent(0.7), resets: false)
        keyboard.highlightKey(noteNumber: 75, color: UIColor.red.withAlphaComponent(0.7), resets: false)
        keyboard.highlightKey(noteNumber: 79, color: UIColor.red.withAlphaComponent(0.7), resets: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func chordDemo() {
        autoHighlight(score: [["C4", "E4", "G4", "B4"],
                              ["D4", "F#4", "A4"],
                              ["E4", "G4", "B4"],
                              ["D4", "F#4", "A4"]
                   ], position: 0, loop: true, tempo: 90.0, play: true)
    }

    private func noteDemo() {
        let alpha: CGFloat = 0.7
        sequence = Sequence(delay: 0.5, functions: {
            self.keyboard.highlightKey(noteNumber: 60, color: UIColor.red.withAlphaComponent(alpha))
        },{
            self.keyboard.highlightKey(noteNumber: 61, color: UIColor.blue.withAlphaComponent(alpha))
        },{
            self.keyboard.highlightKey(noteNumber: 62, color: UIColor.green.withAlphaComponent(alpha))
        },{
            self.keyboard.highlightKey(noteNumber: 63, color: UIColor.yellow.withAlphaComponent(alpha))
        },{
            self.keyboard.highlightKey(noteNumber: 64, color: UIColor.orange.withAlphaComponent(alpha))
        },{
            self.keyboard.highlightKey(noteNumber: 65, color: UIColor.purple.withAlphaComponent(alpha))
        },{
            self.keyboard.highlightKey(noteNumber: 66, color: UIColor.red.withAlphaComponent(alpha))
        },{
            self.keyboard.highlightKey(noteNumber: 67, color: UIColor.blue.withAlphaComponent(alpha))
        },{
            self.keyboard.highlightKey(noteNumber: 68, color: UIColor.green.withAlphaComponent(alpha))
        })
    }

    private func autoHighlight(score: [[String]], position: Int, loop: Bool, tempo: Double, play: Bool = false) {
        keyboard.highlightKeys(noteNames: score[position], color: UIColor.init(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.35), play: play)
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
                    self?.keyboard.reset(didPlay: play)
                }
            }
        }
    }

    func pianoKeyDown(_ keyNumber: Int) {
        audioEngine.sampler.startNote(UInt8(keyboard.octave + keyNumber), withVelocity: 64, onChannel: 0)
    }

    func pianoKeyUp(_ keyNumber: Int) {
        audioEngine.sampler.stopNote(UInt8(keyboard.octave + keyNumber), onChannel: 0)
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

class Sequence {
    let functions : Array<() -> ()>
    let delay: Double
    var functionIndex = 0
    var run = true

    init(delay: Double, functions: (() -> ())...) {
        self.functions = functions
        self.delay = delay
        loop()
    }

    func loop() {
        functions[functionIndex]()
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.functionIndex = (self.functionIndex + 1) % self.functions.count
            if self.run {
                self.loop()
            }
        }
    }

    func stop() {
        run = false
    }
}
