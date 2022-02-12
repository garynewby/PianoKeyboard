//
//  Demo.swift
//  Example
//
//  Created by Gary Newby on 14/08/2020.
//

import Foundation

class Sequence {
    let functions: [() -> Void]
    let delay: Double
    var functionIndex = 0
    var run = true

    init(delay: Double, functions: (() -> Void)...) {
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
