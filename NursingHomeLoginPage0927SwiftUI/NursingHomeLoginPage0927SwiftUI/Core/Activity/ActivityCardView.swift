//  ActivityCardView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/5/24.
//

import SwiftUI
import AVFoundation

struct ActivityCardView: View {
    let activity: Activity
    let AspeechService = SpeechService()
    // Date formatter for the weekday
    private var weekdayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"  // Abbreviated weekday (e.g., "Mon", "Tue")
        return formatter
    }

    // Date formatter for the day
    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"  // Day of the month
        return formatter
    }

    var body: some View {
        HStack(alignment: .top) {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 2)

                HStack(alignment: .top) {
                    // Left side date block
                    VStack {
                        Text(weekdayFormatter.string(from: activity.date))
                            .font(.headline)
                            .foregroundColor(.white)
                        Text(dayFormatter.string(from: activity.date))
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .frame(width: 60, height: 60)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.trailing, 8)

                    // Right side activity details
                    VStack(alignment: .leading, spacing: 5) {
                        Text(activity.title)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.black)

                        HStack(spacing: 5) {
                            Image(systemName: "clock")
                                .foregroundColor(.gray)
                            Text("\(activity.time)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }

                        if !activity.location.isEmpty {
                            HStack(spacing: 5) {
                                Image(systemName: "mappin.and.ellipse")
                                    .foregroundColor(.gray)
                                Text(activity.location)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }

                        if !activity.description.isEmpty {
                            Text(activity.description)
                                .font(.subheadline)
                                .foregroundColor(.black)
                                .lineLimit(2)
                                .truncationMode(.tail)
                        }

                        // Add the speech button
                        Button(action: {
                            speakActivity()  // Call the function to read the activity aloud
                        }) {
                            HStack {
                                Image(systemName: "speaker.wave.2.fill")
                                    .foregroundColor(.blue)
                                Text("Read Aloud")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.top, 8)
                    }
                }
                .padding()
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
    }

    // Function to speak activity details
    private func speakActivity() {
        let activityDetails = """
        The activity is titled \(activity.title).
        It is scheduled on \(weekdayFormatter.string(from: activity.date)), the \(dayFormatter.string(from: activity.date)).
        The time is \(activity.time). Location: \(activity.location.isEmpty ? "No location provided" : activity.location).
        Description: \(activity.description.isEmpty ? "No description available" : activity.description).
        """
        AspeechService.speak(text: activityDetails)
    }
}

// A mock SpeechService class to handle speech synthesis
class ASpeechService {
    private let synthesizer = AVSpeechSynthesizer()

    func speak(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
    }
}
