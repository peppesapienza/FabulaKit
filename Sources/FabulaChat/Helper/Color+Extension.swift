import SwiftUI
import Foundation

#if canImport(UIKit)
extension Color {
   
    /// Initialise a color from an hex string. E.g. `#1fb6ff` or `#7e5bef` are valid hex colors.
    init(hex: String) {
        let regex = try! NSRegularExpression(pattern: "^#(?:[0-9a-fA-F]{3}){1,2}$")
        
        guard regex.firstMatch(in: hex, options: [], range: .init(location: 0, length: hex.utf16.count)) != nil else {
            fatalError("Your color: \(hex) is not a valid hex color")
        }
        
        
        var rgb: UInt64 = 0
        
        let scanner = Scanner(string: hex)
        scanner.currentIndex = hex.index(after: hex.startIndex)
        
        scanner.scanHexInt64(&rgb)
        
        let mask = 0x000000FF
        let r = Int(rgb >> 16) & mask
        let g = Int(rgb >> 8) & mask
        let b = Int(rgb) & mask
        
        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
                
        self.init(
            red: red,
            green: green,
            blue: blue
        )
    }
    
    /// Initialise a Color for dark and light mode using HEX values.
    init(light: String, dark: String) {
        let lightColor = Color(hex: light)
        let darkColor = Color(hex: dark)
        
        let uiColor = UIColor(dynamicProvider: {
            $0.userInterfaceStyle == .dark ? UIColor(darkColor) : UIColor(lightColor)
        })
        
        self.init(uiColor: uiColor)
    }
    
    
    func hex() -> String {
        /// hack to convert to  avoid loosing the cgColor when a Color is created from a `UIColor(dynamicProvider:)`
        guard let components = UIColor(self).cgColor.components else {
            fatalError("Your color: \(self) can't be converted to an hex string")
        }

        return String(
            format: "#%02lX%02lX%02lX",
            lroundf(Float(components[0] * 255)),
            lroundf(Float(components[1] * 255)),
            lroundf(Float(components[2] * 255))
        )
    }

}
#endif
