//
//  The MIT License (MIT)
//
//  Copyright © 2025 Stephan Heilner
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the  Software), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED  AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

public extension Date {
    var calendar: Calendar {
        Calendar.autoupdatingCurrent
    }

    var year: Int {
        calendar.dateComponents([.year], from: self).year ?? 0
    }

    var month: Int {
        calendar.dateComponents([.month], from: self).month ?? 0
    }

    var day: Int {
        calendar.dateComponents([.day], from: self).day ?? 0
    }

    func adding(years: Int? = nil, months: Int? = nil, weeks: Int? = nil, days: Int? = nil, hours: Int? = nil, minutes: Int? = nil, seconds: Int? = nil) -> Date {
        var dateComponent = DateComponents()
        if let years {
            dateComponent.year = years
        }
        if let months {
            dateComponent.month = months
        }
        if let weeks {
            dateComponent.weekOfMonth = weeks
        }
        if let days {
            dateComponent.day = days
        }
        if let hours {
            dateComponent.hour = hours
        }
        if let minutes {
            dateComponent.minute = minutes
        }
        if let seconds {
            dateComponent.second = seconds
        }
        return calendar.date(byAdding: dateComponent, to: self) ?? self
    }

    func setting(month: Int? = nil, day: Int? = nil, year: Int? = nil, hour: Int? = nil, minute: Int? = nil) -> Date {
        var component = calendar.dateComponents([.year, .month, .day], from: self)
        if let year {
            component.year = year
        }
        if let month {
            component.month = month
        }
        if let day {
            component.day = day
        }
        if let hour {
            component.hour = hour
        }
        if let minute {
            component.minute = minute
        }
        return calendar.date(from: component) ?? self
    }

    func startOfMonth(month: Int? = nil, year: Int? = nil) -> Date {
        let date = setting(month: month, year: year)
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components) ?? self
    }

    func endOfMonth(month: Int? = nil, year: Int? = nil) -> Date {
        startOfMonth(month: month, year: year).adding(months: 1, seconds: -1)
    }
}
