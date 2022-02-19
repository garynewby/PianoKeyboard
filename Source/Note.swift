//
//  Notes.swift
//  PianoKeyboard
//
//  Created by Gary Newby on 20/03/2023.
//

import Foundation

public struct Note {
    static let sharps = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
    static let flats  = ["C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B"]

    public static func midiNumber(for name: String) -> Int {
        let note: Substring
        let octave: Int
        if name.contains("-") {
            note = name.dropLast(2)
            octave = name.count > 3 ? Int(name.dropFirst(2)) ?? 0 : Int(name.dropFirst(1)) ?? 0
        } else {
            note = name.dropLast()
            octave = name.count > 2 ? Int(name.dropFirst(2)) ?? 0 : Int(name.dropFirst(1)) ?? 0
        }
        let offset = [sharps.firstIndex(of: String(note)),flats.firstIndex(of: String(note))].compactMap { $0 }.first
        return (12 + (octave * 12)) + (offset ?? 0)
    }

    public static func name(for midiNumber: Int, preferSharps: Bool = false) -> String {
        let offset = midiNumber % 12
        let octave = ((midiNumber - offset) / 12) - 1
        let note = preferSharps ? sharps[offset] : flats[offset]
        return note + String(octave)
    }
}
