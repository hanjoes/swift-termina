@testable import Termbo
import XCTest

final class TermboTests: XCTestCase {
    func testProgressBar() {
        let totalArrows = 25
        var t = Termbo(width: totalArrows + 2, height: 4)
        var last = [String]()
        for i in 1 ... 100 {
            var bars = [String]()
            var num = i
            while num > totalArrows {
                bars.append("[\(String(repeating: ">", count: totalArrows))]")
                num -= totalArrows
            }
            bars.append("[\(String(repeating: ">", count: num))\(String(repeating: "-", count: totalArrows - num))]")
            // print(bars)
            
            t.render(bitmap: bars, to: stdout)
            if i == 100 {
              last = bars
            }
            usleep(10000)
        }
        t.end(withBitmap: last, terminator: "\n")
    }

    func testSpinning() {
        var t = Termbo(width: 1, height: 1)
        let lines = ["|", "\\", "-", "/"]
        for i in 1 ... 100 {
            t.render(bitmap: [lines[i % lines.count]], to: stdout)
            usleep(10000)
        }
        t.end(withBitmap: [""], terminator: "\n")
    }

    static var allTests = [
        ("testProgressBar", testProgressBar),
        // ("testSpinning", testSpinning),
    ]
}
