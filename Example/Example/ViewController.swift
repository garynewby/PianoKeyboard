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

    var engine: AVAudioEngine!
    var sampler: AVAudioUnitSampler!
    
    @IBOutlet weak var keyboardView1: GLNPianoView!
    @IBOutlet weak var keyboardView2: GLNPianoView!
    @IBOutlet weak var keyboardView3: GLNPianoView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardView1.delegate = self;
        keyboardView2.delegate = self;
        keyboardView3.delegate = self;
        startAudioEngine()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func pianoKeyDown(keyNumber:Int) {
        sampler.startNote(UInt8(60 + keyNumber), withVelocity: 64, onChannel: 0)
    }
    
    func pianoKeyUp(keyNumber:Int) {
        sampler.stopNote(UInt8(60 + keyNumber), onChannel: 0)
    }
    
    func startAudioEngine() {
        engine = AVAudioEngine()
        sampler = AVAudioUnitSampler()
        engine.attachNode(sampler)
        engine.connect(sampler, to: engine.mainMixerNode, format: nil)
        
        if engine.running {
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
                audioSession.setCategory(AVAudioSessionCategoryPlayback, withOptions:AVAudioSessionCategoryOptions.MixWithOthers)
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

}

