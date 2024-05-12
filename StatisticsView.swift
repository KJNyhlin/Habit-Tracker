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
    @State private var dailySummary: [String: Int] = [:]
    @State private var weeklySummary: [String: Int] = [:]
    @State private var monthlySummary: [String: Int] = [:]


    var body: some View {
        VStack {
            if longestStreakStartDate != nil {
                Text("Longest Streak: \(longestStreakName) (\(longestStreak) days)")
            } else {
                Text("No streaks available")
            }
            Spacer()
            Spacer()
            
            Text("Daily Summary")
            List(dailySummary.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                Text("\(key): \(value) habits")
            }
            
            Spacer()
            Text("Weekly Summary")
            List(weeklySummary.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                Text("Week \(key): \(value) habits")
            }
            
            
            Text("Monthly Summary")
            List(monthlySummary.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                Text("\(key): \(value) habits")
            }
        }
        .onAppear {
            print("Statistics from UserDefaults: \(UserDefaults.standard.dictionary(forKey: "habitStatistics") ?? [:])")
            calculateStatistics()
        }

    }
    
    



    private func calculateStatistics() {
        var dailyCounts: [String: Int] = [:]
        var weeklyCounts: [String: Int] = [:]
        var monthlyCounts: [String: Int] = [:]
        var longestStreakTemp = 0
        var currentLongestStreakName = ""
        var currentLongestStreakStartDate: Date?

        for (_, details) in statistics {
            if let date = details["date"] as? Date,
               let streak = details["streak"] as? Int,
               let name = details["name"] as? String {
                let day = dateFormatter.string(from: date)
                let week = Calendar.current.component(.weekOfYear, from: date)
                let month = monthFormatter.string(from: date)

                dailyCounts[day, default: 0] += 1
                weeklyCounts["\(week)", default: 0] += 1
                monthlyCounts[month, default: 0] += 1

                if streak > longestStreakTemp {
                    longestStreakTemp = streak
                    currentLongestStreakName = name
                    currentLongestStreakStartDate = date
                }
            }
        }

        dailySummary = dailyCounts
        weeklySummary = weeklyCounts
        monthlySummary = monthlyCounts
        longestStreak = longestStreakTemp  // Säkerställ att detta uppdateras korrekt
        longestStreakName = currentLongestStreakName
        longestStreakStartDate = currentLongestStreakStartDate
    }




    let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MMM"
        formatter.timeZone = TimeZone(identifier: "Europe/Stockholm")
        return formatter
    }()


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
