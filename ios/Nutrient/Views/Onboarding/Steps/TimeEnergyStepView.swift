//
//  TimeEnergyStepView.swift
//  Nutrient
//
//  Created by Nutrient Team on 2026-01-02.
//

import SwiftUI

struct TimeEnergyStepView: View {
    @Binding var profile: UserProfile

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Time & Energy")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text("We want to create meal plans that match your current capacity, not add more stress.")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                VStack(spacing: 20) {
                    // Cooking time preference
                    VStack(alignment: .leading) {
                        Text("Typical Cooking Time")
                            .font(.headline)

                        Text("How much time do you usually have for meal preparation?")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Picker("Cooking Time", selection: $profile.typicalCookingTime) {
                            ForEach(CookingTime.allCases, id: \.self) { time in
                                Text(time.displayName).tag(time)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(height: 120)
                        .clipped()
                    }

                    // Energy level
                    VStack(alignment: .leading) {
                        Text("Current Energy Level")
                            .font(.headline)

                        Text("How would you describe your typical energy for cooking?")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        VStack(spacing: 12) {
                            ForEach(EnergyLevel.allCases, id: \.self) { level in
                                EnergyLevelRow(level: level, isSelected: profile.energyLevelPreference == level) {
                                    profile.energyLevelPreference = level
                                }
                            }
                        }
                    }
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(12)
                .padding(.horizontal)

                // Burnout mode explanation
                if profile.energyLevelPreference == .burnout {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Burnout Mode")
                            .font(.headline)
                            .foregroundColor(.orange)

                        Text("We understand. When you're in burnout mode, we'll prioritize:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        VStack(alignment: .leading, spacing: 8) {
                            BulletPoint(text: "No-cook meals (sandwiches, salads, cheese plates)")
                            BulletPoint(text: "Microwave or minimal stove time")
                            BulletPoint(text: "Pantry-only ingredients when possible")
                            BulletPoint(text: "Takeout or delivery suggestions")
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }

                // Cooking skill level
                VStack(alignment: .leading) {
                    Text("Cooking Skill Level")
                        .font(.headline)

                    Text("This helps us suggest recipes at the right difficulty level.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Picker("Skill Level", selection: $profile.cookingSkillLevel) {
                        ForEach(CookingSkillLevel.allCases, id: \.self) { skill in
                            Text(skill.displayName).tag(skill)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.top, 8)
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(12)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
    }
}

struct EnergyLevelRow: View {
    let level: EnergyLevel
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading) {
                    Text(level.displayName)
                        .font(.headline)
                    Text(level.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .green : .secondary)
            }
            .padding(.vertical, 8)
        }
    }
}

extension EnergyLevel {
    var description: String {
        switch self {
        case .high: return "Ready to cook from scratch"
        case .moderate: return "Some cooking is okay"
        case .low: return "Prefer quick or simple meals"
        case .burnout: return "Need minimal effort right now"
        }
    }
}

struct BulletPoint: View {
    let text: String

    var body: some View {
        HStack(alignment: .top) {
            Text("•")
                .foregroundColor(.green)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

struct TimeEnergyStepView_Previews: PreviewProvider {
    static var previews: some View {
        TimeEnergyStepView(profile: .constant(UserProfile()))
    }
}
