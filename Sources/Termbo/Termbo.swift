import Darwin

/// Escape Sequences
///
/// - setCursor:
///
/// Moves the cursor to the specified position (coordinates).
/// If you do not specify a position, the cursor moves to the home position at the upper-left corner of the screen
/// (line 0, column 0). This escape sequence works the same way as the following Cursor Position escape sequence.
///
/// - cursorUp:
///
/// Moves the cursor up by the specified number of lines without changing columns.
/// If the cursor is already on the top line, ANSI.SYS ignores this sequence.
///
/// - cursorDown:
///
/// Moves the cursor down by the specified number of lines without changing columns.
/// If the cursor is already on the bottom line, ANSI.SYS ignores this sequence.
///
/// - cursorForward:
///
/// Moves the cursor forward by the specified number of columns without changing lines.
/// If the cursor is already in the rightmost column, ANSI.SYS ignores this sequence.
///
/// - cursorBackward:
///
/// Moves the cursor back by the specified number of columns without changing lines.
/// If the cursor is already in the leftmost column, ANSI.SYS ignores this sequence.
///
/// - saveCursor:
///
/// Saves the current cursor position.
/// You can move the cursor to the saved cursor position by using the Restore Cursor Position sequence.
///
/// - restoreCursor:
///
/// Returns the cursor to the position stored by the Save Cursor Position sequence.
///
/// - eraseDisplay:
///
/// Clears the screen and moves the cursor to the home position (line 0, column 0).
///
/// - eraseLine:
///
/// Clears all characters from the cursor position to the end of the line (including the character at the
/// cursor position).
///
/// - graphicsModeOn:
///
/// Calls the graphics functions specified by the following values.
/// These specified functions remain active until the next occurrence of this escape sequence.
/// Graphics mode changes the colors and attributes of text (such as bold and underline) displayed on the screen.
///
/// ```
/// Text       attributes
/// 0          All attributes off
/// 1          Bold on
/// 4          Underscore (on monochrome display adapter only)
/// 5          Blink on
/// 7          Reverse video on
/// 8          Concealed on
///
/// Foreground colors
/// 30         Black
/// 31         Red
/// 32         Green
/// 33         Yellow
/// 34         Blue
/// 35         Magenta
/// 36         Cyan
/// 37         White
///
/// Background colors
/// 40         Black
/// 41         Red
/// 42         Green
/// 43         Yellow
/// 44         Blue
/// 45         Magenta
/// 46         Cyan
/// 47         White
/// ```
///
/// - setMode:
///
/// ```
/// Screen     resolution
/// 0          40 x 25 monochrome (text)
/// 1          40 x 25 color (text)
/// 2          80 x 25 monochrome (text)
/// 3          80 x 25 color (text)
/// 4          320 x 200 4-color (graphics)
/// 5          320 x 200 monochrome (graphics)
/// 6          640 x 200 monochrome (graphics)
/// 7          Enables line wrapping
/// 13         320 x 200 color (graphics)
/// 14         640 x 200 color (16-color graphics)
/// 15         640 x 350 monochrome (2-color graphics)
/// 16         640 x 350 color (16-color graphics)
/// 17         640 x 480 monochrome (2-color graphics)
/// 18         640 x 480 color (16-color graphics)
/// 19         320 x 200 color (256-color graphics)
/// ```
///
/// Changes the screen width or type to the mode specified by one of the following values:
///
/// - resetMode:
///
/// Resets the mode by using the same values that Set Mode uses, except for 7, which disables line wrapping
/// (the last character in this escape sequence is a lowercase L).
///
/// - setKeyboardString:
///
/// Redefines a keyboard key to a specified string.
/// The parameters for this escape sequence are defined as follows:
///
/// Code is one or more of the values listed in the following table.
/// These values represent keyboard keys and key combinations. When using these values in a command,
/// you must type the semicolons shown in this table in addition to the semicolons required by the escape sequence.
/// The codes in parentheses are not available on some keyboards.
/// ANSI.SYS will not interpret the codes in parentheses for those keyboards unless you specify the /X switch in
/// the DEVICE command for ANSI.SYS.
///
/// String is either the ASCII code for a single character or a string contained in quotation marks.
/// For example, both 65 and "A" can be used to represent an uppercase A.
///
/// IMPORTANT: Some of the values in the following table are not valid for all computers. Check your computer's documentation for values that are different.
///
enum EscapeSequence: CustomStringConvertible {
    case setCursor(Int, Int)
    case cursorUp(Int)
    case cursorDown(Int)
    case cursorForward(Int)
    case cursorBackward(Int)
    case saveCursor
    case restoreCursor
    case eraseDisplay
    case eraseLine
    case graphicsModeOn([Int])
    case setMode(Int)
    case resetMode(Int)
    case setKeyboardString([(Int, String)])

    var description: String {
        switch self {
        case let .setCursor(line, col):
            return "\u{1b}[\(line);\(col)H"
        case let .cursorUp(value):
            return "\u{1b}[\(value)A"
        case let .cursorDown(value):
            return "\u{1b}[\(value)B"
        case let .cursorForward(value):
            return "\u{1b}[\(value)C"
        case let .cursorBackward(value):
            return "\u{1b}[\(value)D"
        case .saveCursor:
            return "\u{1b}[s"
        case .restoreCursor:
            return "\u{1b}[u"
        case .eraseDisplay:
            return "\u{1b}[2J"
        case .eraseLine:
            return "\u{1b}[K"
        case let .graphicsModeOn(values):
            return "\u{1b}[\(values.map { String($0) }.joined(separator: ";"))m"
        case let .setMode(value):
            return "\u{1b}[=\(value)h"
        case let .resetMode(value):
            return "\u{1b}[=\(value)l"
        case let .setKeyboardString(mappings):
            return "\u{1b}[\(mappings.map { "\($0.0);\($0.1)" }.joined(separator: ";"))p"
        }
    }
}

struct Termbo {
    private let width: Int
    private let height: Int

    private var renderedHeightSaved: Int = 0
    private var renderedHeight: Int = 0

    init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }

    mutating func rendered(bitmap: [String]) -> String {
        var result = ""
        for (i, row) in bitmap.enumerated() {
            if i >= height { break }
            renderedHeight += 1
            let offset = row.count > width ? width - 1 : row.count
            let endIndex = row.index(row.startIndex, offsetBy: offset)
            let printedRow = String(row[row.startIndex ..< endIndex])
            result = result + printedRow + "\n"
        }
        result = result + restoreCursor()
        return result
    }

    mutating func render(bitmap: [String], to _: UnsafeMutablePointer<FILE>) {
        let renderedString = rendered(bitmap: bitmap)
        fwrite(renderedString, 1, renderedString.count, stdout)
        fflush(stdout)
    }
    
    mutating func clear(_ output: UnsafeMutablePointer<FILE>) {
        let emptyFilling = [String](repeating: String(repeating: " ", count: self.width), count: self.height)
        render(bitmap: emptyFilling, to: output)
    }

    private mutating func restoreCursor() -> String {
        renderedHeightSaved = renderedHeight
        let up = EscapeSequence.cursorUp(renderedHeight).description
        let result = up
        renderedHeight = 0
        return result
    }

    private mutating func restoreCursor() {
        renderedHeightSaved = renderedHeight
        let up = EscapeSequence.cursorUp(renderedHeight).description
        fwrite(up, 1, up.count, stdout)
        renderedHeight = 0
    }

    mutating func end() {
        let down = EscapeSequence.cursorDown(renderedHeightSaved).description
        fwrite(down, 1, down.count, stdout)
        fflush(stdout)
    }
}
