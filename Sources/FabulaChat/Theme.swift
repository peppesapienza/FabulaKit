import SwiftUI

public struct Theme {
    public let colors: ThemeColor
}

public struct ThemeColor {
    public let background: Color
    public let foreground: Color
    public let tint: Color
    public let box: Color
}

/// Exposes the theme as Environment property
extension EnvironmentValues {
    var theme: Theme {
        get { self[Theme.self] }
        set { self[Theme.self] = newValue }
    }
}

extension Theme: EnvironmentKey {
    public static let defaultValue: Theme = .init(
        colors: ThemeColor(
            background: Color(light: "#f8f9fa", dark: "#14213D"),
            foreground: .black,
            tint: Color(hex: "#FCA311"),
            box: Color(light: "#e9ecef", dark: "#4A4E69")
        )
    )
}
