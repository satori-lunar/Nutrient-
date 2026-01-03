//
//  ShoppingListView.swift
//  Nutrient
//
//  Created by Nutrient Team on 2026-01-02.
//

import SwiftUI

struct ShoppingListView: View {
    let plan: MealPlan
    @State private var shoppingList: ShoppingList?
    @State private var isLoading = true

    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Loading shopping list...")
                        .padding()
                } else if let list = shoppingList {
                    ShoppingListContent(list: list)
                } else {
                    EmptyShoppingListView(onGenerate: generateShoppingList)
                }
            }
            .navigationTitle("Shopping List")
            .onAppear(perform: loadShoppingList)
        }
    }

    private func loadShoppingList() {
        // TODO: Load from API
        // For now, simulate loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.shoppingList = ShoppingList(
                id: 1,
                mealPlanId: plan.id!,
                storeName: "Local Grocery Store",
                storeLocation: "123 Main St",
                totalEstimatedCost: 75.50,
                isCompleted: false,
                items: [
                    ShoppingListItem(id: 1, shoppingListId: 1, name: "Chicken Breast", quantity: 2.0, unit: "lbs", estimatedPrice: 8.99, category: "Meat", isPurchased: false, alternativeSuggestions: nil),
                    ShoppingListItem(id: 2, shoppingListId: 1, name: "Rice", quantity: 5.0, unit: "lbs", estimatedPrice: 4.99, category: "Pantry", isPurchased: true, alternativeSuggestions: nil),
                    ShoppingListItem(id: 3, shoppingListId: 1, name: "Broccoli", quantity: 1.0, unit: "head", estimatedPrice: 2.49, category: "Produce", isPurchased: false, alternativeSuggestions: nil)
                ]
            )
            self.isLoading = false
        }
    }

    private func generateShoppingList() {
        // TODO: Call API to generate shopping list
        loadShoppingList()
    }
}

struct EmptyShoppingListView: View {
    let onGenerate: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "list.bullet")
                .font(.system(size: 60))
                .foregroundColor(.secondary)

            Text("No shopping list yet")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Generate a shopping list from your meal plan to see what you need to buy.")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button(action: onGenerate) {
                Text("Generate Shopping List")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }

            Spacer()
        }
        .padding()
    }
}

struct ShoppingListContent: View {
    @State var list: ShoppingList

    var body: some View {
        VStack {
            // Header with store info
            VStack(alignment: .leading, spacing: 8) {
                if let storeName = list.storeName {
                    Text(storeName)
                        .font(.headline)
                }

                if let location = list.storeLocation {
                    Text(location)
                        .foregroundColor(.secondary)
                }

                HStack {
                    Text("Total estimated: $\(list.totalEstimatedCost ?? 0, specifier: "%.2f")")
                        .font(.subheadline)
                        .foregroundColor(.green)

                    Spacer()

                    Text("\(list.items.filter { $0.isPurchased }.count)/\(list.items.count) purchased")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(12)
            .padding(.horizontal)

            // Items grouped by category
            ScrollView {
                let groupedItems = Dictionary(grouping: list.items) { $0.category ?? "Other" }
                let sortedCategories = groupedItems.keys.sorted()

                ForEach(sortedCategories, id: \.self) { category in
                    ShoppingCategorySection(
                        category: category,
                        items: groupedItems[category] ?? [],
                        onItemToggle: { item in
                            toggleItemPurchase(item)
                        }
                    )
                }
            }
        }
    }

    private func toggleItemPurchase(_ item: ShoppingListItem) {
        if let index = list.items.firstIndex(where: { $0.id == item.id }) {
            list.items[index].isPurchased.toggle()
        }
    }
}

struct ShoppingCategorySection: View {
    let category: String
    let items: [ShoppingListItem]
    let onItemToggle: (ShoppingListItem) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(category)
                .font(.headline)
                .padding(.horizontal)

            ForEach(items) { item in
                ShoppingListItemRow(item: item, onToggle: { onItemToggle(item) })
            }
        }
        .padding(.vertical, 8)
    }
}

struct ShoppingListItemRow: View {
    let item: ShoppingListItem
    let onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            HStack {
                Image(systemName: item.isPurchased ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(item.isPurchased ? .green : .secondary)

                VStack(alignment: .leading) {
                    Text(item.name)
                        .strikethrough(item.isPurchased)
                        .foregroundColor(item.isPurchased ? .secondary : .primary)

                    Text("\(item.quantity, specifier: "%.1f") \(item.unit)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                if let price = item.estimatedPrice {
                    Text("$\(price, specifier: "%.2f")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .foregroundColor(.primary)
    }
}

struct ShoppingListView_Previews: PreviewProvider {
    static var previews: {
        let samplePlan = MealPlan(
            id: 1,
            userId: 1,
            name: "This Week's Meals",
            startDate: Date(),
            endDate: Date().addingTimeInterval(86400 * 7),
            budgetLimit: 100.0,
            totalEstimatedCost: 85.50,
            recipes: []
        )
        return ShoppingListView(plan: samplePlan)
    }()
}
