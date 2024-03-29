//
//  String+Extension.swift
//  FUNCOIN
//
//  Created by Yate Fulham on 2018/08/10.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation

extension String {
    func stripHexPrefix() -> String {
        if self.hasPrefix("0x") {
            let indexStart = self.index(self.startIndex, offsetBy: 2)
            return String(self[indexStart...])
        }
        return self
    }

    func addHexPrefix() -> String {
        if !self.hasPrefix("0x") {
            return "0x" + self
        }
        return self
    }

    func substring(from: Int) -> String {
        return String(dropFirst(from))
    }

    func substring(to: Int) -> String {
        return String(dropLast(count - to))
    }
}
