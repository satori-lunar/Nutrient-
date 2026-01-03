//
//  CompleteStepView.swift
//  Nutrient
//
//  Created by Nutrient Team on 2026-01-02.
//

import SwiftUI

struct CompleteStepView: View {
    @Binding var profile: UserProfile
    let onComplete: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Spacer()

                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.green)
                    .padding(.bottom, 16)

                Text("You're all set!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text("We've got everything we need to create meal plans that fit your life.")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                VStack(alignment: .leading, spacing: 16) {
                    SummaryRow(icon: "house.fill", title: "Household", value: "\(profile.householdSize) people")
                    SummaryRow(icon: "location.fill", title: "Location", value: profile.city.isEmpty ? "Not specified" : "\(profile.city), \(profile.state)")
                    SummaryRow(icon: "clock.fill", title: "Cooking Time", value: profile.typicalCookingTime.displayName)
                    SummaryRow(icon: "battery.75", title: "Energy Level", value: profile.energyLevelPreference.displayName)

                    if !profile.culturalBackground.isEmpty {
                        SummaryRow(icon: "globe", title: "Culture", value: profile.culturalBackground)
                    }

                    if !profile.favoriteCuisines.isEmpty {
                        SummaryRow(icon: "fork.knife", title: "Cuisines", value: profile.favoriteCuisines.joined(separator: ", "))
                    }
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(12)
                .padding(.horizontal)

                VStack(spacing: 16) {
                    Text("What happens next?")
                        .font(.headline)

                    VStack(alignment: .leading, spacing: 12) {
                        NextStepRow(number: "1", text: "We'll create your first meal plan based on your preferences")
                        NextStepRow(number: "2", text: "You can scan pantry items to get \"cook now\" suggestions")
                        NextStepRow(number: "3", text: "We'll learn from your feedback to improve suggestions")
                    }
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(12)
                .padding(.horizontal)

                Spacer()

                Button(action: onComplete) {
                    Text("Start Planning Meals")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .padding(.bottom, 40)
            }
            .padding(.vertical)
        }
    }
}

struct SummaryRow: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.green)
                .frame(width: 24, height: 24)

            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(width: 80, alignment: .leading)

            Text(value)
                .font(.subheadline)
                .foregroundColor(.primary)
        }
    }
}

struct NextStepRow: View {
    let number: String
    let text: String

    var body: some View {
        HStack(alignment: .top) {
            Text(number)
                .font(.headline)
                .foregroundColor(.green)
                .frame(width: 24, height: 24)
                .background(Circle().fill(Color.green.opacity(0.2)))

            Text(text)
                .font(.subheadline)
                .foregroundColor(.primary)
        }
    }
}

struct CompleteStepView_Previews: PreviewProvider {
    static var previews: some View {
        CompleteStepView(profile: .constant(UserProfile()), onComplete: {})
    }
}
