import Foundation

struct Template {
    
    static let regex: String = #"(\$\{[a-z0-9_]*\})"#
    
    init(_ base: String) {
        self.base = base
    }
    
    let base: String
    
    func build(_ inputs: [String : Any]) -> String {
        do {
            return try base.replace(regex: Template.regex) { match in
                let key = sanitise(match)
                
                guard let value = inputs[key] else {
                    throw BotError.templateKeyIsMissing(key: key, template: base)
                }
                
                return "\(value)"
            }
        } catch {
            print(error)
            return base
        }
    }
    
    /// Removes the `${}` chars from the matched regex
    private func sanitise(_ s: Substring) -> String {
        var s = s
        s.removeFirst(2)
        s.removeLast(1)
        return "\(s)"
    }
}

extension String {
    /// Replace a regex match in place and returns the resulted string.
    ///
    /// - parameters:
    ///  - regex: The regular expression
    ///  - handler: Captures the matched `String.SubQueuence`
    func replace(regex: String, _ handler: (SubSequence) throws -> (String)) rethrows -> String {
        var result: String = ""
        var i = startIndex
        
        while i < endIndex, let range = self[i...].range(of: regex, options: .regularExpression) {
            result += self[i..<range.lowerBound]
            result += try handler(self[range])
            
            i = range.lowerBound < range.upperBound
                ? range.upperBound
                : index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        
        if i < endIndex {
            result += self[i..<endIndex]
        }
        
        return result
    }
}
