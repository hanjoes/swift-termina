enum EscapeSequence: CustomStringConvertible {
    case setCursor(Int, Int)
    case cursorUp
    case cursorDown
    case cursorForward
    case cursorBackward
    case saveCursor
    case restoreCursor
    case eraseDisplay
    case eraseLine
    case graphicsModeOn([Int])
    case graphicModeOff
    case setMode(Int)
    case resetMode
    case setKeyboardString(Int, String)
    
    var description: String {
        return ""
    }
}

struct Termbo {
}
