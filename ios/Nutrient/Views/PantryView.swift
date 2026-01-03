//
//  PantryView.swift
//  Nutrient
//
//  Created by Nutrient Team on 2026-01-02.
//

import SwiftUI
import AVFoundation

struct PantryView: View {
    @EnvironmentObject var appState: AppState
    @State private var pantryItems: [PantryItem] = []
    @State private var showingAddItemSheet = false
    @State private var showingBarcodeScanner = false
    @State private var showingCookNowSuggestions = false
    @State private var isLoading = false

    var body: some View {
        NavigationView {
            VStack {
                // Header with actions
                HStack {
                    Text("Your Pantry")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Spacer()

                    HStack(spacing: 12) {
                        Button(action: { showingBarcodeScanner = true }) {
                            Image(systemName: "barcode.viewfinder")
                                .font(.title2)
                                .foregroundColor(.green)
                        }

                        Button(action: { showingAddItemSheet = true }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.green)
                        }
                    }
                }
                .padding(.horizontal)

                // Cook Now Suggestions Button
                Button(action: { showingCookNowSuggestions = true }) {
                    HStack {
                        Image(systemName: "flame.fill")
                        Text("Cook Now Suggestions")
                        Spacer()
                        Text("\(pantryItems.count) items")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                .foregroundColor(.primary)

                // Pantry Items List
                if pantryItems.isEmpty && !isLoading {
                    EmptyPantryView(onAddItem: { showingAddItemSheet = true })
                } else {
                    PantryItemsList(items: pantryItems, onDelete: deleteItem)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingAddItemSheet) {
                AddPantryItemView(onItemAdded: addItemToPantry)
            }
            .sheet(isPresented: $showingBarcodeScanner) {
                BarcodeScannerView(onBarcodeScanned: handleBarcodeScanned)
            }
            .sheet(isPresented: $showingCookNowSuggestions) {
                CookNowSuggestionsView()
            }
            .onAppear(perform: loadPantryItems)
        }
    }

    private func loadPantryItems() {
        isLoading = true
        // TODO: Load pantry items from API
        // For now, using mock data
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.pantryItems = [
                PantryItem(userId: 1, name: "Milk", barcode: nil, quantity: 1, unit: "gallon", category: "Dairy", expirationDate: Date().addingTimeInterval(86400 * 5), purchaseDate: Date(), estimatedValue: 3.99, isPerishable: true, storageLocation: "fridge", notes: nil),
                PantryItem(userId: 1, name: "Bread", barcode: nil, quantity: 1, unit: "loaf", category: "Bakery", expirationDate: Date().addingTimeInterval(86400 * 3), purchaseDate: Date(), estimatedValue: 2.49, isPerishable: true, storageLocation: "pantry", notes: nil),
                PantryItem(userId: 1, name: "Chicken Breast", barcode: nil, quantity: 2, unit: "lbs", category: "Meat", expirationDate: Date().addingTimeInterval(86400 * 2), purchaseDate: Date(), estimatedValue: 8.99, isPerishable: true, storageLocation: "freezer", notes: nil)
            ]
            self.isLoading = false
        }
    }

    private func addItemToPantry(_ item: PantryItem) {
        pantryItems.append(item)
        showingAddItemSheet = false
    }

    private func deleteItem(_ item: PantryItem) {
        pantryItems.removeAll { $0.id == item.id }
    }

    private func handleBarcodeScanned(_ barcode: String) {
        showingBarcodeScanner = false
        // TODO: Look up product by barcode and show add item sheet
        showingAddItemSheet = true
    }
}

struct EmptyPantryView: View {
    let onAddItem: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "archivebox")
                .font(.system(size: 60))
                .foregroundColor(.secondary)

            Text("Your pantry is empty")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Add items manually or scan barcodes to start building your pantry inventory.")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            VStack(spacing: 12) {
                Button(action: onAddItem) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add Item Manually")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }

                Text("Or scan a barcode to get started")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
    }
}

struct PantryItemsList: View {
    let items: [PantryItem]
    let onDelete: (PantryItem) -> Void

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(items) { item in
                    PantryItemCard(item: item, onDelete: { onDelete(item) })
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
        }
    }
}

struct PantryItemCard: View {
    let item: PantryItem
    let onDelete: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)

                HStack {
                    Text("\(item.quantity, specifier: "%.1f") \(item.unit)")
                    if let expirationDate = item.expirationDate {
                        Text("•")
                        Text(expirationText(for: expirationDate))
                            .foregroundColor(expirationColor(for: expirationDate))
                    }
                }
                .font(.subheadline)
                .foregroundColor(.secondary)

                if let location = item.storageLocation {
                    Text(location.capitalized)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }

    private func expirationText(for date: Date) -> String {
        let daysUntilExpiration = Calendar.current.dateComponents([.day], from: Date(), to: date).day ?? 0

        if daysUntilExpiration < 0 {
            return "Expired"
        } else if daysUntilExpiration == 0 {
            return "Expires today"
        } else if daysUntilExpiration == 1 {
            return "Expires tomorrow"
        } else {
            return "Expires in \(daysUntilExpiration) days"
        }
    }

    private func expirationColor(for date: Date) -> Color {
        let daysUntilExpiration = Calendar.current.dateComponents([.day], from: Date(), to: date).day ?? 0

        if daysUntilExpiration < 0 {
            return .red
        } else if daysUntilExpiration <= 2 {
            return .orange
        } else {
            return .green
        }
    }
}

struct PantryView_Previews: PreviewProvider {
    static var previews: some View {
        PantryView()
            .environmentObject(AppState())
    }
}
