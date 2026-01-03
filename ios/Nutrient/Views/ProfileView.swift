//
//  ProfileView.swift
//  Nutrient
//
//  Created by Nutrient Team on 2026-01-02.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack {
            if let profile = appState.currentUser {
                VStack(spacing: 20) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.green)

                    Text("Your Profile")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    VStack(alignment: .leading, spacing: 12) {
                        ProfileInfoRow(label: "Household Size", value: "\(profile.householdSize) people")
                        ProfileInfoRow(label: "Location", value: profile.city.isEmpty ? "Not set" : "\(profile.city), \(profile.state)")
                        ProfileInfoRow(label: "Budget", value: profile.weeklyBudget.map { "$\($0)/week" } ?? "Not set")
                        ProfileInfoRow(label: "Cooking Time", value: profile.typicalCookingTime.displayName)
                        ProfileInfoRow(label: "Energy Level", value: profile.energyLevelPreference.displayName)

                        if !profile.culturalBackground.isEmpty {
                            ProfileInfoRow(label: "Culture", value: profile.culturalBackground)
                        }

                        if !profile.favoriteCuisines.isEmpty {
                            ProfileInfoRow(label: "Cuisines", value: profile.favoriteCuisines.joined(separator: ", "))
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)

                    Button(action: {
                        // Reset onboarding
                        appState.isOnboardingCompleted = false
                        appState.currentUser = nil
                        UserDefaults.standard.removeObject(forKey: "isOnboardingCompleted")
                        UserDefaults.standard.removeObject(forKey: "currentUser")
                    }) {
                        Text("Restart Setup")
                            .foregroundColor(.red)
                            .padding()
                    }

                    Spacer()
                }
                .padding()
            } else {
                Text("No profile found")
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("Profile")
    }
}

struct ProfileInfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .foregroundColor(.primary)
                .multilineTextAlignment(.trailing)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AppState())
    }
}
