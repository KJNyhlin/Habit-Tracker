//
//  StatisticsView.swift
//  HabitMaker
//
//  Created by Karl Nyhlin on 2024-05-10.
//

import SwiftUI

struct StatisticsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var statistics: [String: [String: Any]] = UserDefaults.standard.dictionary(forKey: "habitStatistics") as? [String: [String: Any]] ?? [:]
    @State private var habitCountsByDate: [String: Int] = [:]
    @State private var longestStreakName: String = ""
    @State private var longestStreakStartDate: Date?
    @State private var longestStreak: Int = 0


    var body: some View {
        VStack {
            if longestStreakStartDate != nil {
                Text("Longest Streak: \(longestStreakName) (\(longestStreak) days)")//, Streak started on \(dateFormatter.string(from: startDate))")
            } else {
                Text("No streaks available")
            }
            SimpleBarChartView(data: habitCountsByDate.map { (key, value) in
                DailyHabitData(date: dateFormatter.date(from: key) ?? Date(), count: value)
            }.sorted(by: { $0.date < $1.date }))
        }
        .onAppear {
            calculateStatistics()
        }
    }
    
    

    private func calculateStatistics() {
        var countsByDate: [String: Int] = [:]
        var longestStreak = 0
        var currentLongestStreakName = ""
        var currentLongestStreakStartDate: Date?

        for (_, details) in statistics {
            if let date = details["date"] as? Date,
               let streak = details["streak"] as? Int,
               let name = details["name"] as? String {
                let dateString = dateFormatter.string(from: date)
                countsByDate[dateString, default: 0] += 1
                    
                if streak > longestStreak {
                    longestStreak = streak
                    currentLongestStreakName = name
                    currentLongestStreakStartDate = date
                }
            }
        }

        habitCountsByDate = countsByDate
        longestStreakName = currentLongestStreakName
        longestStreakStartDate = currentLongestStreakStartDate
        self.longestStreak = longestStreak
    }

}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    if let timeZone = TimeZone(identifier: "Europe/Stockholm") {
        formatter.timeZone = timeZone
    } else {
        print("Failed to set timezone")
    }
    return formatter
}()


struct DailyHabitData: Identifiable {
    let id = UUID()
    var date: Date
    var count: Int
}

struct SimpleBarChartView: View {
    var data: [DailyHabitData]

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(data) { datum in
                HStack {
                    Text(dateFormatter.string(from: datum.date))
                        .frame(width: 100)
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: CGFloat(datum.count) * 20, height: 20)
                }
            }
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}
