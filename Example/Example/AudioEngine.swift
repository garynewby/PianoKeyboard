//
//  ViewController.swift
//  Example
//
//  Created by gary on 17/05/2016.
//  Copyright © 2016 Gary Newby. All rights reserved.
//

import UIKit
import AVFoundation


class AudioEngine {
 
    var engine = AVAudioEngine()
    var sampler = AVAudioUnitSampler()
    var reverb = AVAudioUnitReverb()
    var delay = AVAudioUnitDelay()
    
    func start() {
        engine = AVAudioEngine()
        sampler = AVAudioUnitSampler()
        
        engine.attach(sampler)
        engine.attach(reverb)
        engine.attach(delay)

        engine.connect(sampler, to: delay, format: nil)
        engine.connect(delay, to: reverb, format: nil)
        engine.connect(reverb, to: engine.mainMixerNode, format: nil)
        
        // Reverb
        reverb.loadFactoryPreset(.mediumHall)
        reverb.wetDryMix = 30.0;
        
        // Delay
        delay.wetDryMix     = 15.0;
        delay.delayTime     = 0.50;
        delay.feedback      = 75.0;
        delay.lowPassCutoff = 16000.0;
        
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

}






