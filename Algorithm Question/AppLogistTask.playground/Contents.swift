import UIKit

/*
 * Complete the 'shortestSubstring' function below. *
 * The function is expected to return an INTEGER.
 * The function accepts STRING s as parameter. */
func shortestSubstring(s: String) -> Int {
    
    var uniqueChars : [Character] = []
    var count : Int!
    
    for index in s.indices {
        if !uniqueChars.contains(s[index]) {
            uniqueChars.append(s[index])
        }
    }
    
    count = uniqueChars.count
    var smallestSubstring = s
    
    for index in s.indices {
        let substring = s[index...]
        
        var subCounter = 0
        var subChars : [Character] = []
        
        for index2 in substring.indices {
            if !subChars.contains(substring[index2]) {
                subCounter += 1
                subChars.append(substring[index2])
            }
            
            if subCounter == count {
                if substring[index...index2].count < smallestSubstring.count {
                    smallestSubstring = String(substring[index...index2])
                }
                
                break
            }
        }
    }
    
    print(smallestSubstring)
    
    return smallestSubstring.count
}

shortestSubstring(s: "aaacabcbcbcbc")
