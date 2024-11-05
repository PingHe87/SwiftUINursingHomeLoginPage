//  AddActivityView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/5/24.
//


struct IdentifiableCoordinate: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

import SwiftUI
import MapKit

struct AddActivityView: View {
    @Environment(\.presentationMode) var presentationMode  // Dismiss view when done
    @ObservedObject var activityViewModel: ActivityViewModel  // View model reference

    @State private var title: String = ""
    @State private var date: Date = Date()
    @State private var time: Date = Date()  // Changed to Date type for time picker
    @State private var location: String = ""
    @State private var description: String = ""
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),  // Default to San Francisco
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var selectedCoordinate: IdentifiableCoordinate?
    @State private var showAlert = false  // State to control the alert display

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Activity Details")) {
                    TextField("Title", text: $title)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
                    
                    // Interactive Map for selecting location
                    VStack {
                        Text("Select Location")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, annotationItems: selectedCoordinate == nil ? [] : [selectedCoordinate!]) { coordinate in
                            MapPin(coordinate: coordinate.coordinate, tint: .blue)
                        }
                        .frame(height: 200)
                        .cornerRadius(10)
                        .onTapGesture {
                            // Get coordinate from tap and set as selected
                            let tapLocation = region.center
                            selectedCoordinate = IdentifiableCoordinate(coordinate: tapLocation)
                            updateLocationName(for: tapLocation)
                        }
                    }
                    if !location.isEmpty {
                        Text("Selected Location: \(location)")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    TextField("Description", text: $description)
                }
            }
            .navigationTitle("Add New Activity")
            .navigationBarItems(trailing: Button("Save") {
                // Check if the title is empty
                if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    showAlert = true  // Show alert if title is empty
                } else {
                    let timeFormatter = DateFormatter()
                    timeFormatter.timeStyle = .short
                    let formattedTime = timeFormatter.string(from: time)

                    let newActivity = Activity(title: title, date: date, time: formattedTime, location: location, description: description)
                    activityViewModel.activities.append(newActivity)
                    presentationMode.wrappedValue.dismiss()  // Close the view
                }
            })
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Invalid Input"),
                    message: Text("The title field cannot be empty. Please provide a title for the activity."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    // Function to update the location name from coordinates
    private func updateLocationName(for coordinate: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first, error == nil {
                self.location = [placemark.name, placemark.locality, placemark.administrativeArea, placemark.country].compactMap { $0 }.joined(separator: ", ")
            } else {
                self.location = "Unknown location"
            }
        }
    }
}

// Preview for development purposes
#Preview {
    AddActivityView(activityViewModel: ActivityViewModel())
}
