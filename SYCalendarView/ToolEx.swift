//
//  ColorEx.swift
//  SpeakTap
//
//  Created by IOS4 on 2024/12/4.
//

import Foundation
import SwiftUI

// 扩展 Color 来支持 HEX 初始值
extension Color {
    init(hex: String) {
        let r, g, b: Double
        
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexString = hexString.replacingOccurrences(of: "#", with: "")
        
        // 确保 hex 长度为 6 位
        guard hexString.count == 6,
              let rgb = UInt64(hexString, radix: 16) else {
            self.init(red: 255, green: 255, blue: 255)
            return
        }
        
        r = Double((rgb >> 16) & 0xFF) / 255.0
        g = Double((rgb >> 8) & 0xFF) / 255.0
        b = Double(rgb & 0xFF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
}


extension Date {
    /// 将 Date 转换为指定格式的字符串
    /// - Parameter format: 日期格式字符串
    /// - Returns: 格式化后的日期字符串
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func getDateString(format:String = "yyyy-MM-dd HH:mm") ->String{
        
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = format
        dateFormatter.locale = .current
        let dateStr = dateFormatter.string(from: self)
        return dateStr
    }
}

extension Array {
    // 将数组按指定大小分块
    func chunked(into chunkSize: Int) -> [[Element]] {
        var chunks: [[Element]] = []
        for index in stride(from: 0, to: count, by: chunkSize) {
            let chunk = Array(self[index..<Swift.min(index + chunkSize, count)])
            chunks.append(chunk)
        }
        return chunks
    }
}
