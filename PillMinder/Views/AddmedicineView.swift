//
//  AddmedicineView.swift
//  PillMinder
//
//  Created by Leann Hashishi on 7/6/23.
//

import SwiftUI

struct TransparentTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.clear) // Set the background color to transparent
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black, lineWidth: 1) // Add a border
            )
    }
}

struct AddmedicineView: View {
    
    let notify = NotificationHandler()
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var shelveviewModel: ShelvesviewModel
    
    // individual name, frequency, and time
    @State var medicineName: String = ""
    @State var reminderFrequency: String = ""
    @State var customDays: Int = 2
    @State var timeOfDay: Date = Date()
    
    // refill reminder states
    @State var remindToRefill: Bool = false
    @State var refillDate: Date = Date()
    
    // alerts
    @State var alertTitle: String = ""
    @State var showAlert: Bool = false
    
    let reminderFrequencies = ["Daily", "Weekdays", "Weekends", "Every __ Days", "Biweekly"]
    
    var body: some View {
        ZStack {
            Color("creme").ignoresSafeArea()
            
            VStack {
                
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Label("", systemImage: "house").foregroundColor(.black)
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                Text("Add New Medicine")
                    .font(.custom(FontsManager.Avenir.heavy, size: 35))
                    .fontWeight(.semibold)
                    .padding(.top, 10)
                
                Rectangle()
                    .frame(width: 200, height: 2)
                    .foregroundColor(.black)
                
                VStack {
                    Form {
                        Section(header: Text("Medicine Name").foregroundColor(Color("darknavy"))) {
                            TextField("", text: $medicineName)
                                .textFieldStyle(TransparentTextFieldStyle())
                        }.listRowBackground(Color.clear)

                        Section(header: Text("Reminder").foregroundColor(Color("darknavy"))) {
                            Picker("Frequency", selection: $reminderFrequency) {
                                ForEach(reminderFrequencies, id: \.self) { frequency in
                                    Text(frequency)
                                }
                            }
                            .onChange(of: reminderFrequency) { newValue in
                                if newValue != "Every __ Days" {
                                    customDays = 2 // Reset customDays when not using "Every X Days"
                                }
                            }
                            
                            if reminderFrequency == "Every __ Days" {
                                Stepper(value: $customDays, in: 1...30) {
                                    Text("Repeat every \(customDays) days")
                                }
                            }
                            
                            DatePicker("Time", selection: $timeOfDay, displayedComponents: .hourAndMinute)
                                .datePickerStyle(.compact)
                        }.listRowBackground(Color.clear)
                        
                        Section {
                            Toggle("Remind me when to refill", isOn: $remindToRefill)
                            
                            if remindToRefill {
                                DatePicker("Refill Date", selection: $refillDate, displayedComponents: .date)
                            }
                        }.listRowBackground(Color.clear)
                        
                        Section {
                            Button(action: saveReminder) {
                                Text("Save")
                                    .font(.custom(FontsManager.Avenir.heavy, size: 30))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("creme"))
                                    .padding()
                                    .background(Color("lightnavy"))
                                    .cornerRadius(40)
                            }.listRowBackground(Color.clear)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .scrollContentBackground(.hidden)
                .alert(isPresented: $showAlert, content: getAlert)
            }
        }
    }
    
    func saveReminder() {
        print("🚀 saveReminder() called for \(medicineName)")
        
        if validateInput() {
            let finalFreq = reminderFrequency == "Every __ Days" ? "Every \(customDays) Days" : reminderFrequency
            
            shelveviewModel.addItem(name: medicineName, freq: finalFreq, time: timeOfDay)
            
            print("🔹 Calling sendNotification() for \(medicineName)")
            notify.sendNotification(time: timeOfDay, freq: finalFreq, type: "time", title: medicineName, body: "It's time to take your medicine!")
            
            if remindToRefill {
                notify.scheduleRefillReminder(date: refillDate, title: medicineName)
            }
            
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    func getAlert() -> Alert {
        return Alert(title: Text(alertTitle))
    }
    
    func validateInput() -> Bool {
        if medicineName.isEmpty {
            alertTitle = "Your medicine name must be at least 1 character."
            showAlert.toggle()
            return false
        }
        
        if reminderFrequency.isEmpty {
            alertTitle = "Please pick a frequency."
            showAlert.toggle()
            return false
        }
        
        if timeOfDay == Date() {
            alertTitle = "Please pick a time."
            showAlert.toggle()
            return false
        }
        
        return true
    }
}

struct AddmedicineView_Previews: PreviewProvider {
    static var previews: some View {
        AddmedicineView()
            .environmentObject(ShelvesviewModel())
            .environmentObject(UserSettings())
    }
}
