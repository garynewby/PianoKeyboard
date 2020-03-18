import Foundation

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
