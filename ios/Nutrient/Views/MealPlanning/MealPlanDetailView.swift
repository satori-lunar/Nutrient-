//
//  MealPlanDetailView.swift
//  Nutrient
//
//  Created by Nutrient Team on 2026-01-02.
//

import SwiftUI

struct MealPlanDetailView: View {
    let plan: MealPlan
    @State private var showingShoppingList = false
    @State private var showingEditPlan = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Plan header
                VStack(alignment: .leading, spacing: 8) {
                    Text(plan.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    HStack {
                        Label(formatDateRange(plan.startDate, plan.endDate), systemImage: "calendar")
                        Spacer()
                        if let budget = plan.budgetLimit {
                            Label("Budget: $\(budget, specifier: "%.0f")", systemImage: "dollarsign.circle")
                        }
                    }
                    .foregroundColor(.secondary)

                    if let cost = plan.totalEstimatedCost {
                        Text("Estimated cost: $\(cost, specifier: "%.2f")")
                            .font(.headline)
                            .foregroundColor(.green)
                    }
                }
                .padding(.horizontal)

                // Quick actions
                HStack(spacing: 12) {
                    ActionButton(title: "Shopping List", icon: "list.bullet", action: { showingShoppingList = true })
                    ActionButton(title: "Edit Plan", icon: "pencil", action: { showingEditPlan = true })
                    ActionButton(title: "Share", icon: "square.and.arrow.up", action: { /* Share action */ })
                }
                .padding(.horizontal)

                // Meals by day
                VStack(alignment: .leading, spacing: 16) {
                    Text("Meals")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.horizontal)

                    if plan.recipes.isEmpty {
                        Text("No meals planned yet. Add some recipes to get started!")
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    } else {
                        MealsByDayView(recipes: plan.recipes)
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingShoppingList) {
            ShoppingListView(plan: plan)
        }
    }

    private func formatDateRange(_ start: Date, _ end: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none

        if Calendar.current.isDate(start, inSameDayAs: end) {
            return formatter.string(from: start)
        } else {
            return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
        }
    }
}

struct ActionButton: View {
    let title: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(12)
        }
        .foregroundColor(.primary)
    }
}

struct MealsByDayView: View {
    let recipes: [MealPlanRecipe]

    var body: some View {
        let groupedRecipes = Dictionary(grouping: recipes) { recipe in
            Calendar.current.startOfDay(for: recipe.scheduledDate)
        }

        let sortedDates = groupedRecipes.keys.sorted()

        ForEach(sortedDates, id: \.self) { date in
            DayMealsView(date: date, meals: groupedRecipes[date] ?? [])
        }
    }
}

struct DayMealsView: View {
    let date: Date
    let meals: [MealPlanRecipe]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(formatDate(date))
                .font(.headline)
                .padding(.horizontal)

            ForEach(meals) { meal in
                MealCard(recipe: meal)
            }
        }
        .padding(.vertical, 8)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
        .padding(.horizontal)
    }

    private func formatDate(_ date: Date) -> String {
        if Calendar.current.isDateInToday(date) {
            return "Today"
        } else if Calendar.current.isDateInTomorrow(date) {
            return "Tomorrow"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE, MMM d"
            return formatter.string(from: date)
        }
    }
}

struct MealCard: View {
    let recipe: MealPlanRecipe

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(recipe.mealType.capitalized)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text("Recipe #\(recipe.recipeId)") // TODO: Show actual recipe name
                    .font(.body)

                if recipe.isAlternative {
                    Text("Alternative option")
                        .font(.caption)
                        .foregroundColor(.orange)
                }

                if let notes = recipe.notes {
                    Text(notes)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            VStack(alignment: .trailing) {
                Text("\(recipe.servings) servings")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Button(action: { /* Edit meal */ }) {
                    Image(systemName: "pencil")
                        .foregroundColor(.blue)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

struct MealPlanDetailView_Previews: PreviewProvider {
    static var previews: {
        let samplePlan = MealPlan(
            id: 1,
            userId: 1,
            name: "This Week's Meals",
            startDate: Date(),
            endDate: Date().addingTimeInterval(86400 * 7),
            budgetLimit: 100.0,
            totalEstimatedCost: 85.50,
            recipes: [
                MealPlanRecipe(id: 1, mealPlanId: 1, recipeId: 1, scheduledDate: Date(), mealType: "dinner", servings: 4, isAlternative: false, notes: nil)
            ]
        )
        return MealPlanDetailView(plan: samplePlan)
    }()
}
