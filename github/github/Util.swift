//
//  Util.swift
//  github
//
//  Created by Harry on 2022/03/30.
//

import Foundation

class Util {
    static func getConsonant(text: String) -> String {
        return text.consonant()
    }
}

extension String {

    private static let hangul = ["ㄱ","ㄲ","ㄴ","ㄷ","ㄸ","ㄹ","ㅁ","ㅂ","ㅃ","ㅅ","ㅆ","ㅇ","ㅈ","ㅉ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"]

    func consonant() -> String {
        let text = self.trimmingCharacters(in: .whitespacesAndNewlines)
        guard text.count > 0 else { return "" }
        if let consonant = getInitialConsonant(text: text) {
            return consonant
        } else {
            return "\(text.first!)".uppercased()
        }
    }

    func getInitialConsonant(text: String) -> String? {
        guard let firstChar = text.unicodeScalars.first?.value, 0xAC00...0xD7A3 ~= firstChar else { return nil }

        let value = ((firstChar - 0xac00) / 28 ) / 21
        return Self.hangul[Int(value)]
//        return String(format:"%C", value + 0x1100)
    }
}
