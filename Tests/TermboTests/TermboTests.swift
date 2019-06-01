import XCTest
@testable import Termbo

final class TermboTests: XCTestCase {
    func testExample() {
        var t = Termbo(width: 27, height: 4)
        for i in 1 ... 100 {
            var bars = [String]()
            var numArrows = i
            while numArrows > 25 {
                bars.append("[>>>>>>>>>>>>>>>>>>>>>>>>>]")
                numArrows -= 25
            }
            bars.append("[\(String(repeating: ">", count: numArrows))\(String(repeating: "-", count: 25 - numArrows))]")
            t.render(bitmap: bars)
            sleep(1)
        }
        t.end()
    }
    

    static var allTests = [
        ("testExample", testExample),
    ]
}
