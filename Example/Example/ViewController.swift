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
    @IBOutlet weak var stepper: UIStepper!
    var engine: AVAudioEngine!
    var sampler: AVAudioUnitSampler!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardView.delegate = self;
        stepper.value = Double(keyboardView.totalNumKeys)
        startAudioEngine()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func pianoKeyDown(_ keyNumber:Int) {
        sampler.startNote(UInt8(60 + keyNumber), withVelocity: 64, onChannel: 0)
    }
    
    func pianoKeyUp(_ keyNumber:Int) {
        sampler.stopNote(UInt8(60 + keyNumber), onChannel: 0)
    }
    
    func startAudioEngine() {
        engine = AVAudioEngine()
        sampler = AVAudioUnitSampler()
        engine.attach(sampler)
        engine.connect(sampler, to: engine.mainMixerNode, format: nil)
        
        if engine.isRunning {
            print("audio engine already running")
            return
        }
        do {
            try engine.start()
            print("audio engine started")
        } catch {
            print("could not start audio engine")
            return
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try
                audioSession.setCategory(AVAudioSessionCategoryPlayback, with:AVAudioSessionCategoryOptions.mixWithOthers)
        } catch {
            print("audioSession: couldn't set category \(error)")
            return
        }
        do {
            try audioSession.setActive(true)
        } catch {
            print("audioSession: couldn't set category active \(error)")
            return
        }
    }

    @IBAction func stepperTapped(_ sender: AnyObject) {
        if let stepper = sender as? UIStepper {
            keyboardView.setNumberOfKeys(count: Int(stepper.value))
        }
    }
}






