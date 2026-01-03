//
//  FamilyMembersStepView.swift
//  Nutrient
//
//  Created by Nutrient Team on 2026-01-02.
//

import SwiftUI

struct FamilyMembersStepView: View {
    @Binding var profile: UserProfile
    @State private var familyMembers: [FamilyMember] = []

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Family Members")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text("Tell us about the people in your household so we can create personalized meal suggestions.")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                if familyMembers.isEmpty {
                    EmptyFamilyStateView(onAddMember: addNewMember)
                } else {
                    FamilyMembersListView(members: $familyMembers, onAddMember: addNewMember)
                }
            }
            .padding(.vertical)
        }
        .onAppear {
            // Load existing family members if any
        }
    }

    private func addNewMember() {
        let newMember = FamilyMember(name: "", age: nil, relationship: "child")
        familyMembers.append(newMember)
    }
}

struct EmptyFamilyStateView: View {
    let onAddMember: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "person.3.fill")
                .font(.system(size: 60))
                .foregroundColor(.secondary)

            Text("Add Family Members")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Help us understand everyone's preferences and restrictions for better meal planning.")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button(action: onAddMember) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Family Member")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .cornerRadius(12)
                .padding(.horizontal)
            }
        }
        .padding(.vertical, 40)
    }
}

struct FamilyMembersListView: View {
    @Binding var members: [FamilyMember]
    let onAddMember: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            ForEach($members.indices, id: \.self) { index in
                FamilyMemberCard(member: $members[index]) {
                    members.remove(at: index)
                }
            }

            Button(action: onAddMember) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.green)
                    Text("Add Another Family Member")
                        .foregroundColor(.green)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
            }
        }
    }
}

struct FamilyMemberCard: View {
    @Binding var member: FamilyMember
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                TextField("Name", text: $member.name)
                    .font(.headline)
                    .textFieldStyle(.roundedBorder)

                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }

            HStack {
                TextField("Age (optional)", value: $member.age, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                    .frame(width: 120)

                Spacer()

                Picker("Relationship", selection: $member.relationship) {
                    Text("Parent").tag("parent")
                    Text("Child").tag("child")
                    Text("Spouse").tag("spouse")
                    Text("Other").tag("other")
                }
                .pickerStyle(.menu)
            }

            VStack(alignment: .leading) {
                Text("Preferences & Restrictions")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                TextField("e.g., Loves pizza, allergic to nuts", text: .constant(""))
                    .textFieldStyle(.roundedBorder)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct FamilyMembersStepView_Previews: PreviewProvider {
    static var previews: some View {
        FamilyMembersStepView(profile: .constant(UserProfile()))
    }
}
