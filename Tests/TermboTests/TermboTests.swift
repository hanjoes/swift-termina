@testable import Termbo
import XCTest

struct Colors {
  static let Red = EscapeSequence.graphicsModeOn([31]).description
  static let Green = EscapeSequence.graphicsModeOn([32]).description
  static let Yellow = EscapeSequence.graphicsModeOn([33]).description
  static let Cyan = EscapeSequence.graphicsModeOn([36]).description
  static let Blink = EscapeSequence.graphicsModeOn([5]).description
  static let Reset = EscapeSequence.graphicsModeOn([0]).description
}

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
    t.end(withBitmap: last, terminator: "\n", to: stdout)
  }

  func testSpinning() {
    var t = Termbo(width: 1, height: 1)
    let lines = ["|", "\\", "-", "/"]
    for i in 1 ... 100 {
      t.render(bitmap: [lines[i % lines.count]], to: stdout)
      usleep(10000)
    }
    t.end(withBitmap: [""], terminator: "\n", to: stdout)
  }

  func testPromptRendering() {
    let PS1 = "\(Colors.Yellow)hanjoes\(Colors.Reset)"
      + "@\(Colors.Red)192.168.0.1\(Colors.Reset)"
      + " \(Colors.Yellow)(*masterx)\(Colors.Reset) > "
    let PS2 = "\(Colors.Yellow)hanjoes\(Colors.Reset)"
      + "@\(Colors.Red)192.168.0.1\(Colors.Reset)"
      + " \(Colors.Green)(master x)\(Colors.Reset) > "
    var t = Termbo(width: PS1.count, height: 1)

    t.render(bitmap: [PS1], to: stdout)
    sleep(2)
    t.end(withBitmap: [PS2], terminator: "\n", to: stdout)
  }

  static var allTests = [
    // ("testProgressBar", testProgressBar),
    // ("testSpinning", testSpinning),
    ("testPromptRendering", testPromptRendering),
  ]
}
