//
//  AddPantryItemView.swift
//  Nutrient
//
//  Created by Nutrient Team on 2026-01-02.
//

import SwiftUI

struct AddPantryItemView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var quantity: Double = 1.0
    @State private var unit = "count"
    @State private var category = ""
    @State private var expirationDate: Date = Date().addingTimeInterval(86400 * 7) // 7 days from now
    @State private var purchaseDate: Date = Date()
    @State private var estimatedValue: Double?
    @State private var isPerishable = true
    @State private var storageLocation = "pantry"
    @State private var notes = ""

    let commonUnits = ["count", "lbs", "oz", "cups", "gallons", "pieces"]
    let commonCategories = ["Dairy", "Meat", "Produce", "Bakery", "Pantry Staples", "Frozen", "Canned", "Snacks"]
    let storageLocations = ["pantry", "fridge", "freezer", "counter"]

    let onItemAdded: (PantryItem) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Basic Information")) {
                    TextField("Item Name", text: $name)

                    HStack {
                        Text("Quantity")
                        Spacer()
                        TextField("Quantity", value: $quantity, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                    }

                    Picker("Unit", selection: $unit) {
                        ForEach(commonUnits, id: \.self) { unit in
                            Text(unit).tag(unit)
                        }
                    }
                }

                Section(header: Text("Details")) {
                    Picker("Category", selection: $category) {
                        Text("Select Category").tag("")
                        ForEach(commonCategories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }

                    Picker("Storage Location", selection: $storageLocation) {
                        ForEach(storageLocations, id: \.self) { location in
                            Text(location.capitalized).tag(location)
                        }
                    }

                    Toggle("Perishable", isOn: $isPerishable)
                }

                Section(header: Text("Dates & Value")) {
                    DatePicker("Purchase Date", selection: $purchaseDate, displayedComponents: .date)

                    if isPerishable {
                        DatePicker("Expiration Date", selection: $expirationDate, displayedComponents: .date)
                    }

                    HStack {
                        Text("Estimated Value ($)")
                        Spacer()
                        TextField("Value", value: $estimatedValue, format: .currency(code: "USD"))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                    }
                }

                Section(header: Text("Notes")) {
                    TextEditor(text: $notes)
                        .frame(height: 80)
                }
            }
            .navigationTitle("Add Pantry Item")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    saveItem()
                }
                .disabled(name.isEmpty)
            )
        }
    }

    private func saveItem() {
        let item = PantryItem(
            userId: 1, // TODO: Get from app state
            name: name,
            barcode: nil,
            quantity: quantity,
            unit: unit,
            category: category.isEmpty ? nil : category,
            expirationDate: isPerishable ? expirationDate : nil,
            purchaseDate: purchaseDate,
            estimatedValue: estimatedValue,
            isPerishable: isPerishable,
            storageLocation: storageLocation,
            notes: notes.isEmpty ? nil : notes
        )

        onItemAdded(item)
    }
}

struct AddPantryItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddPantryItemView(onItemAdded: { _ in })
    }
}
