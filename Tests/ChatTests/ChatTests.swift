import XCTest
@testable import FabulaChat
import SwiftUI
import FabulaCore
import Combine

final class ChatTests: XCTestCase {
    
    func testColorFromHex() throws {
        
        let grayLight = "#d3dce6"
        let grayDark = "#273444"
        
        let blueHex = "#1fb6ff"
        
        let blueColor = Color(hex: blueHex)
        XCTAssertEqual(blueColor.hex(), blueHex.uppercased())
        
        let grayLightColor = Color(hex: grayLight)
        let grayDarkColor = Color(hex: grayDark)
        XCTAssertEqual(grayLightColor.hex(), grayLight.uppercased())
        XCTAssertEqual(grayDarkColor.hex(), grayDark.uppercased())
        
        let dynamicGrayColor = Color(light: grayLight, dark: grayDark)
        XCTAssertEqual(dynamicGrayColor.hex(), grayLight.uppercased())
        
    }


}
