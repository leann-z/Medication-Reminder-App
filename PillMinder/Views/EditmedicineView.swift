//
//  EditmedicineView.swift
//  PillMinder
//
//  Created by Leann Hashishi on 7/17/23.
//

import SwiftUI

struct EditmedicineView: View {
    
    var dismissAction: (() -> Void)?
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var shelveviewModel: ShelvesviewModel
    let notify = NotificationHandler()
    
    @State var item: ItemModel
    @State var editedName: String = ""
    @State var editedFreq: String = ""
    @State var editedCustomDays: Int = 2
    @State var editedTime: Date = Date()
    
    @State var remindToRefill: Bool = false
    @State var refillDate: Date = Date()
    
    // alerts
    @State var alertTitle: String = ""
    @State var showAlert: Bool = false
    
    let reminderFrequencies = ["Daily", "Weekdays", "Weekends", "Every __ Days", "Biweekly"]
    
    // initializer to autofill the form with current info
    init(item: ItemModel) {
        self._item = State(initialValue: item)
        self._editedName = State(initialValue: item.name)
        self._editedTime = State(initialValue: item.time ?? Date())
        self._remindToRefill = State(initialValue: item.remindToRefill ?? false)
        self._refillDate = State(initialValue: item.refillDate ?? Date())

        if item.freq.starts(with: "Every") && item.freq.contains("Days") {
            let components = item.freq.components(separatedBy: " ")
            if components.count > 1, let dayValue = Int(components[1]) {
                self._editedFreq = State(initialValue: "Every __ Days")
                self._editedCustomDays = State(initialValue: dayValue)
            } else {
                self._editedFreq = State(initialValue: item.freq) // Default case
                self._editedCustomDays = State(initialValue: 2)
            }
        } else {
            self._editedFreq = State(initialValue: item.freq) // Autofill for other frequencies
            self._editedCustomDays = State(initialValue: 2) // Default if not "Every __ Days"
        }
    }
    
    var body: some View {
        ZStack {
            Color("creme").ignoresSafeArea()
            
            VStack {
                
                // Title and Close Button
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // 🔹 Close Sheet
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color("lightnavy"))
                    }
                    .padding()
                    
                    Spacer()
                }
                
                Text("Edit Medicine")
                    .font(.custom(FontsManager.Avenir.heavy, size: 35))
                    .fontWeight(.semibold).foregroundColor(Color("darknavy"))
                
                Rectangle()
                    .frame(width: 200, height: 2)
                    .foregroundColor(.black)
                
                VStack {
                    Form {
                        Section(header: Text("Medicine Name").foregroundColor(Color("darknavy"))) {
                            TextField("", text: $editedName)
                                .textFieldStyle(TransparentTextFieldStyle())
                        }.listRowBackground(Color.clear)
                        
                        Section(header: Text("Reminder").foregroundColor(Color("darknavy"))) {
                            Picker(selection: $editedFreq, label: Text("Frequency").foregroundColor(Color("darknavy"))) {
                                ForEach(reminderFrequencies, id: \.self) { frequency in
                                    Text(frequency)
                                }
                            }.tint(Color("darknavy"))
                            .onChange(of: editedFreq) { newValue in
                                if newValue != "Every __ Days" {
                                    editedCustomDays = 2 // Reset if switching away
                                }
                            }

                            if editedFreq == "Every __ Days" {
                                Stepper(value: $editedCustomDays, in: 1...30) {
                                    Text("Repeat every \(editedCustomDays) days")
                                }
                            }
                            
                            DatePicker(selection: $editedTime, displayedComponents: .hourAndMinute) {
                                Text("Time").foregroundColor(Color("darknavy"))
                            }
                                .datePickerStyle(.compact)
                        }
                        .listRowBackground(Color.clear)
                        
                        Section {
                            Toggle(isOn: $remindToRefill) {
                                Text("Remind me when to refill").foregroundColor(Color("darknavy"))
                            }
                            
                            if remindToRefill {
                                DatePicker("Refill Date", selection: $refillDate, displayedComponents: .date).foregroundColor(Color("darknavy"))
                            }
                        }.listRowBackground(Color.clear)
                        
                        Section {
                            Button(action: {
                                saveReminder(item: $item, editedName: editedName, editedFreq: editedFreq, editedTime: editedTime, shelvesviewModel: shelveviewModel)
                            }) {
                                Text("Save")
                                    .font(.custom(FontsManager.Avenir.heavy, size: 30))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("creme"))
                                    .padding()
                                    .background(Color("lightnavy"))
                                    .cornerRadius(40)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .listRowBackground(Color.clear)
                    }
                }
                .scrollContentBackground(.hidden)
                .alert(isPresented: $showAlert, content: getAlert)
                
                Spacer()
            }
        }
    }
    
    func saveReminder(item: Binding<ItemModel>, editedName: String, editedFreq: String, editedTime: Date, shelvesviewModel: ShelvesviewModel) {
        
        self.item.name = editedName
        self.item.freq = editedFreq
        self.item.time = editedTime
        
        if validateInput() {
            
            shelvesviewModel.updateItem(item: item.wrappedValue)
            
            notify.sendNotification(time: editedTime, freq: editedFreq, type: "time", title: editedName, body: "It's time to take your medicine!")
            
            // Update refill reminder if changed
            if remindToRefill {
                notify.scheduleRefillReminder(date: refillDate, title: editedName)
            }
            
            presentationMode.wrappedValue.dismiss() // Close Sheet
        }
    }
    
    func getAlert() -> Alert {
        return Alert(title: Text(alertTitle))
    }
    
    func validateInput() -> Bool {
        if editedName.count < 1 {
            alertTitle = "Your medicine name must be at least 1 character."
            showAlert.toggle()
            return false
        }
        
        if editedFreq.isEmpty {
            alertTitle = "Please pick a frequency."
            showAlert.toggle()
            return false
        }
        
        if editedTime == Date() {
            alertTitle = "Please pick a time."
            showAlert.toggle()
            return false
        }
        
        return true
    }
}

struct EditmedicineView_Previews: PreviewProvider {
    static var item1 = ItemModel(name: "Accutane", freq: "Daily", time: Date())
    
    static var previews: some View {
        EditmedicineView(item: item1)
            .environmentObject(ShelvesviewModel())
            .environmentObject(UserSettings())
    }
}
