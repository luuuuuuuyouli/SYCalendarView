//
//  CalendarView.swift
//  DrinkEase
//
//  Created by Ios5 on 2024/12/26.
//

import SwiftUI

struct CalendarView: View {
    
    @State private var selectMonthDate: Date = Date() // 月份切换选择日期
    @State var selectedDate: Date = Date() // 点击选中的日期
    
    private let todayDate: Date = Date() // 今天
    
    private let selectColor:Color = Color(hex: "#30AEEE")
    private let selectTextColor:Color = Color.white
    private let textRadius:CGFloat = 20

    private let daysOfWeek = ["S", "M", "T", "W", "T", "F", "S"]
    
    var dateChange: ((Date) -> Void)?

    var body: some View {
        VStack {
            // 顶部的月份和切换按钮
            HStack {
                Button(action: {
                    changeMonth(by: -1) // 上一个月
                }) {
                    Image("icon_month_last")
                }
                
                Spacer()
                
                Text(monthYearString)
                    .font(.headline)
                
                Spacer()
                
                Button(action: {
                    changeMonth(by: 1) // 下一个月
                }) {
                    Image("icon_month_next")
                }
            }
            .padding()

            // 星期标题
            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .frame(width: 40, height: 40)
                        .font(Font.system(size: 12,weight: .medium))
                        .foregroundColor(Color.white)
                        .cornerRadius(5)
                }
            }.background(Color(hex: "#30AEEE"))

            // 日期
            let firstDayOfMonth = getFirstDayOfMonth()
            let totalDays = getTotalDaysInMonth()
            let lastDayOfMonth = totalDays + firstDayOfMonth
            
            let previousMonthDate = Calendar.current.date(byAdding: .month, value: -1, to: selectMonthDate)!
            let nextMonthDate = Calendar.current.date(byAdding: .month, value: 1, to: selectMonthDate)!
            
            var currentComponents = Calendar.current.dateComponents([.year, .month], from: selectMonthDate)
            var previousComponents = Calendar.current.dateComponents([.year, .month], from: previousMonthDate)
            var nextComponents = Calendar.current.dateComponents([.year, .month], from: nextMonthDate)
        
            // 计算上个月的最后几天
            let previousMonthDays = getDaysFromPreviousMonth(count: firstDayOfMonth).map { day in
                previousComponents.day = day
                return Calendar.current.date(from: previousComponents)!
            }
            // 计算下个月的天数
            let nextMonthDays = getDaysFromNextMonth(count: (7 - (lastDayOfMonth % 7)) % 7).map { day in
                nextComponents.day = day
                return Calendar.current.date(from: nextComponents)!
            }
            
            let currentDays = Array(1...totalDays).map{ day in
                currentComponents.day = day
                return Calendar.current.date(from: currentComponents)!
            }
            
            // 组合显示的日期
            let daysToShow = previousMonthDays + currentDays + nextMonthDays

            let rows = daysToShow.chunked(into: 7)
            
            ForEach(rows, id: \.self) { row in
                HStack{
                    ForEach(row, id: \.self) { day in
                        Text("\(day.getDateString(format:"d"))")
                            .frame(width: 40, height: 40)
                            .font(Font.system(size: 12))
                            .background(selectedDate.getDateString(format: "yyyy-MM-dd") == day.getDateString(format: "yyyy-MM-dd") ? selectColor : Color.clear)
                            .foregroundColor(getTextColor(day: day))
                            .cornerRadius(textRadius)
                            .onTapGesture {
                                // 当前月份的日期
                                selectedDate = day
                                printSelectedDate() // 打印选中日期
                                dateChange?(day)
                        }
                    }
                }
            }
        }
        .padding()
    }
    
    private func printSelectedDate() {
       
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: selectedDate)
        print("选中日期: \(dateString)")
    }

    // 获取当前月份的字符串表示
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM, yyyy"
        return formatter.string(from: selectMonthDate)
    }

    // 切换月份
    private func changeMonth(by value: Int) {
        let calendar = Calendar.current
        selectMonthDate = calendar.date(byAdding: .month, value: value, to: selectMonthDate) ?? selectMonthDate
    }

    // 计算一个月的第一天是星期几
    private func getFirstDayOfMonth() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: selectMonthDate)
        let date = calendar.date(from: components)!
        let weekday = calendar.component(.weekday, from: date)
        return weekday - 1 // 将星期日调整为0
    }

    // 获取一个月的天数
    private func getTotalDaysInMonth() -> Int {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: selectMonthDate)
        return range?.count ?? 0
    }

    // 获取上个月的最后几天
    private func getDaysFromPreviousMonth(count: Int) -> [Int] {
        let calendar = Calendar.current
        let previousMonthDate = calendar.date(byAdding: .month, value: -1, to: selectMonthDate)!
        let totalDays = getTotalDaysInMonth(for: previousMonthDate)
        if totalDays >= totalDays - count + 1{
            return Array((totalDays - count + 1)...totalDays)
        }
        return []
    }

    // 获取下个月的天数
    private func getDaysFromNextMonth(count: Int) -> [Int] {
        if count >= 1{
            return Array(1...count)
        }
        return []
    }
    
    // 获取指定日期月份的天数
    private func getTotalDaysInMonth(for date: Date) -> Int {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: date)
        return range?.count ?? 0
    }
    
    func areDatesInSameMonth(date: Date) -> Bool {
        let calendar = Calendar.current
        
        // 获取第一个日期的年份和月份
        let components1 = calendar.dateComponents([.year, .month], from: date)
        
        // 获取第二个日期的年份和月份
        let components2 = calendar.dateComponents([.year, .month], from: selectMonthDate)
        
        // 比较年份和月份
        return components1.year == components2.year && components1.month == components2.month
    }
    
    private func getTextColor(day:Date) ->Color{
        print("day",day)
        
        if selectedDate.getDateString(format: "yyyy-MM-dd") == day.getDateString(format: "yyyy-MM-dd"){
            return selectTextColor
        }
        
        if day.getDateString(format: "yyyy-MM-dd") == todayDate.getDateString(format: "yyyy-MM-dd"){
            return Color.orange
        }
        
        if areDatesInSameMonth(date: day){
            return Color.black
        }else {
            return Color(hex: "#DADADA")
        }
    }


}



#Preview {
    CalendarView()
}
