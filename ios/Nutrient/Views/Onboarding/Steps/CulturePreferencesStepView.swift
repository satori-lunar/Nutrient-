//
//  CulturePreferencesStepView.swift
//  Nutrient
//
//  Created by Nutrient Team on 2026-01-02.
//

import SwiftUI

struct CulturePreferencesStepView: View {
    @Binding var profile: UserProfile
    @State private var newCuisine = ""
    @State private var newTraditionalMeal = ""
    @State private var newRestriction = ""
    @State private var newDislikedIngredient = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Culture & Preferences")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text("Help us understand your food culture and preferences so we can suggest meals that feel like home.")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                // Cultural background
                VStack(alignment: .leading) {
                    Text("Cultural Background")
                        .font(.headline)

                    Text("Where does your family's food culture come from? (Optional)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    TextField("e.g., Italian-American, Mexican, Southern", text: $profile.culturalBackground)
                        .textFieldStyle(.roundedBorder)
                        .padding(.top, 8)
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(12)
                .padding(.horizontal)

                // Traditional meals
                VStack(alignment: .leading) {
                    Text("Traditional Meals")
                        .font(.headline)

                    Text("What are some traditional or comfort foods your family enjoys?")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    HStack {
                        TextField("e.g., Grandma's spaghetti, Sunday tamales", text: $newTraditionalMeal)
                            .textFieldStyle(.roundedBorder)
                        Button(action: addTraditionalMeal) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                        .disabled(newTraditionalMeal.isEmpty)
                    }

                    if !profile.traditionalMeals.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(profile.traditionalMeals, id: \.self) { meal in
                                    TagView(text: meal) {
                                        profile.traditionalMeals.removeAll { $0 == meal }
                                    }
                                }
                            }
                        }
                        .padding(.top, 8)
                    }
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(12)
                .padding(.horizontal)

                // Favorite cuisines
                VStack(alignment: .leading) {
                    Text("Favorite Cuisines")
                        .font(.headline)

                    Text("What types of food do you and your family enjoy?")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    HStack {
                        TextField("e.g., Italian, Thai, Mexican", text: $newCuisine)
                            .textFieldStyle(.roundedBorder)
                        Button(action: addCuisine) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                        .disabled(newCuisine.isEmpty)
                    }

                    if !profile.favoriteCuisines.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(profile.favoriteCuisines, id: \.self) { cuisine in
                                    TagView(text: cuisine) {
                                        profile.favoriteCuisines.removeAll { $0 == cuisine }
                                    }
                                }
                            }
                        }
                        .padding(.top, 8)
                    }
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(12)
                .padding(.horizontal)

                // Dietary restrictions
                VStack(alignment: .leading) {
                    Text("Dietary Restrictions")
                        .font(.headline)

                    Text("Any allergies, intolerances, or dietary preferences?")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    HStack {
                        TextField("e.g., Gluten-free, Nut allergy, Vegetarian", text: $newRestriction)
                            .textFieldStyle(.roundedBorder)
                        Button(action: addRestriction) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                        .disabled(newRestriction.isEmpty)
                    }

                    if !profile.dietaryRestrictions.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(profile.dietaryRestrictions, id: \.self) { restriction in
                                    TagView(text: restriction) {
                                        profile.dietaryRestrictions.removeAll { $0 == restriction }
                                    }
                                }
                            }
                        }
                        .padding(.top, 8)
                    }
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(12)
                .padding(.horizontal)

                // Disliked ingredients
                VStack(alignment: .leading) {
                    Text("Disliked Ingredients")
                        .font(.headline)

                    Text("Any ingredients your family generally avoids?")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    HStack {
                        TextField("e.g., Mushrooms, Cilantro, Brussels sprouts", text: $newDislikedIngredient)
                            .textFieldStyle(.roundedBorder)
                        Button(action: addDislikedIngredient) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                        .disabled(newDislikedIngredient.isEmpty)
                    }

                    if !profile.dislikedIngredients.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(profile.dislikedIngredients, id: \.self) { ingredient in
                                    TagView(text: ingredient) {
                                        profile.dislikedIngredients.removeAll { $0 == ingredient }
                                    }
                                }
                            }
                        }
                        .padding(.top, 8)
                    }
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(12)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
    }

    private func addTraditionalMeal() {
        if !newTraditionalMeal.isEmpty && !profile.traditionalMeals.contains(newTraditionalMeal) {
            profile.traditionalMeals.append(newTraditionalMeal)
            newTraditionalMeal = ""
        }
    }

    private func addCuisine() {
        if !newCuisine.isEmpty && !profile.favoriteCuisines.contains(newCuisine) {
            profile.favoriteCuisines.append(newCuisine)
            newCuisine = ""
        }
    }

    private func addRestriction() {
        if !newRestriction.isEmpty && !profile.dietaryRestrictions.contains(newRestriction) {
            profile.dietaryRestrictions.append(newRestriction)
            newRestriction = ""
        }
    }

    private func addDislikedIngredient() {
        if !newDislikedIngredient.isEmpty && !profile.dislikedIngredients.contains(newDislikedIngredient) {
            profile.dislikedIngredients.append(newDislikedIngredient)
            newDislikedIngredient = ""
        }
    }
}

struct TagView: View {
    let text: String
    let onRemove: () -> Void

    var body: some View {
        HStack {
            Text(text)
                .font(.subheadline)
                .foregroundColor(.primary)
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color(.tertiarySystemGroupedBackground))
        .cornerRadius(16)
    }
}

struct CulturePreferencesStepView_Previews: PreviewProvider {
    static var previews: some View {
        CulturePreferencesStepView(profile: .constant(UserProfile()))
    }
}
