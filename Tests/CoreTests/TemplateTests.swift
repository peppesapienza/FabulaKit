import XCTest
@testable import FabulaCore

final class TemplateTests: XCTestCase {
    
    func test_templateAreFilled_whenValidInputs() throws {
        
        let inputs: [String : Any] = [
            "var_username": "Giuseppe",
            "age": 28,
            "city1": "Melbourne",
            "cities": ["Melbourne", "Catania"]
        ]
        
        XCTAssertEqual(Template("${var_username}").build(inputs), "Giuseppe")
        XCTAssertEqual(Template("${age} 🧑‍💻").build(inputs), "28 🧑‍💻")
        XCTAssertEqual(Template("🌏 ${city1}!").build(inputs), "🌏 Melbourne!")
        
        /// Maybe this would requires some normalisation, eg: "places: Melbourne, Catania"
        XCTAssertEqual(Template("places: ${cities}").build(inputs), "places: [\"Melbourne\", \"Catania\"]")
        
        XCTAssertEqual(Template("${city1}!\n${age}").build(inputs), """
        Melbourne!
        28
        """)
        
        XCTAssertEqual(Template("no template").build(inputs), "no template")
        XCTAssertEqual(Template("").build(inputs), "")
       
        
        let t1 = Template("hello ${var_username}, you are ${age} years old and your current city is ${city1}!")
        XCTAssertEqual(t1.build(inputs), "hello Giuseppe, you are 28 years old and your current city is Melbourne!")
    }
    
    func test_templateReturnsBaseString_whenSomeKeyIsMissing() {
        XCTAssertEqual(Template("value: ${some_key}").build([:]), "value: ${some_key}")
        XCTAssertEqual(Template("value1: ${key1}, value2: ${key2}").build(["key1":"1"]), "value1: ${key1}, value2: ${key2}")
    }
    
}
