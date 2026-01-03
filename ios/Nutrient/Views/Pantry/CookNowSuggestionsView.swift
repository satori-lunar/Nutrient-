//
//  CookNowSuggestionsView.swift
//  Nutrient
//
//  Created by Nutrient Team on 2026-01-02.
//

import SwiftUI

struct CookNowSuggestionsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var recipes: [Recipe] = []
    @State private var isLoading = true

    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Finding recipes...")
                        .padding()
                } else if recipes.isEmpty {
                    EmptySuggestionsView()
                } else {
                    RecipesList(recipes: recipes)
                }
            }
            .navigationTitle("Cook Now")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
            .onAppear(perform: loadSuggestions)
        }
    }

    private func loadSuggestions() {
        // TODO: Load from API based on pantry items
        // For now, using mock data
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.recipes = [
                Recipe(id: 1, name: "Quick Pasta", description: "Simple pasta dish with pantry staples", prepTimeMinutes: 5, cookTimeMinutes: 15, servings: 4, difficulty: "easy", cuisineType: "Italian", ingredients: [
                    RecipeIngredient(id: 1, name: "Pasta", quantity: 1, unit: "lb", isOptional: false, notes: nil),
                    RecipeIngredient(id: 2, name: "Tomato Sauce", quantity: 1, unit: "jar", isOptional: false, notes: nil),
                    RecipeIngredient(id: 3, name: "Cheese", quantity: 0.5, unit: "cup", isOptional: true, notes: "Optional topping")
                ], instructions: "Boil pasta, heat sauce, mix together."),
                Recipe(id: 2, name: "Egg Fried Rice", description: "Quick rice dish with eggs and vegetables", prepTimeMinutes: 10, cookTimeMinutes: 10, servings: 2, difficulty: "easy", cuisineType: "Asian", ingredients: [
                    RecipeIngredient(id: 4, name: "Rice", quantity: 2, unit: "cups", isOptional: false, notes: "Cooked rice"),
                    RecipeIngredient(id: 5, name: "Eggs", quantity: 2, unit: "count", isOptional: false, notes: nil),
                    RecipeIngredient(id: 6, name: "Frozen Vegetables", quantity: 1, unit: "cup", isOptional: true, notes: "Any frozen veggies")
                ], instructions: "Heat oil, scramble eggs, add rice and veggies, stir fry."),
                Recipe(id: 3, name: "Grilled Cheese Sandwich", description: "Classic comfort food", prepTimeMinutes: 2, cookTimeMinutes: 5, servings: 1, difficulty: "easy", cuisineType: "American", ingredients: [
                    RecipeIngredient(id: 7, name: "Bread", quantity: 2, unit: "slices", isOptional: false, notes: nil),
                    RecipeIngredient(id: 8, name: "Cheese", quantity: 2, unit: "slices", isOptional: false, notes: nil),
                    RecipeIngredient(id: 9, name: "Butter", quantity: 1, unit: "tbsp", isOptional: false, notes: nil)
                ], instructions: "Butter bread, add cheese, grill until golden.")
            ]
            self.isLoading = false
        }
    }
}

struct EmptySuggestionsView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.secondary)

            Text("No recipes found")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Try adding more items to your pantry or check back later for new suggestions.")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}

struct RecipesList: View {
    let recipes: [Recipe]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(recipes) { recipe in
                    RecipeCard(recipe: recipe)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct RecipeCard: View {
    let recipe: Recipe

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(recipe.name)
                .font(.headline)

            if let description = recipe.description {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            HStack {
                Label("\(recipe.prepTimeMinutes + recipe.cookTimeMinutes) min", systemImage: "clock")
                Spacer()
                Label("\(recipe.servings) servings", systemImage: "person.2")
                Spacer()
                Text(recipe.difficulty.capitalized)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(difficultyColor(for: recipe.difficulty))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .font(.caption)
            }
            .font(.caption)
            .foregroundColor(.secondary)

            VStack(alignment: .leading, spacing: 4) {
                Text("Ingredients you have:")
                    .font(.subheadline)
                    .fontWeight(.medium)

                ForEach(recipe.ingredients) { ingredient in
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .frame(width: 16)
                        Text("\(ingredient.quantity, specifier: "%.1f") \(ingredient.unit) \(ingredient.name)")
                            .font(.caption)
                    }
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }

    private func difficultyColor(for difficulty: String) -> Color {
        switch difficulty.lowercased() {
        case "easy": return .green
        case "medium": return .orange
        case "hard": return .red
        default: return .gray
        }
    }
}

struct CookNowSuggestionsView_Previews: PreviewProvider {
    static var previews: some View {
        CookNowSuggestionsView()
    }
}
