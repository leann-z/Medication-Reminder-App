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

extension Date: RawRepresentable {
    public var rawValue: String {
        self.timeIntervalSinceReferenceDate.description
    }
    
    public init?(rawValue: String) {
        self = Date(timeIntervalSinceReferenceDate: Double(rawValue) ?? 0.0)
    }
}



struct AddmedicineView: View {
    
    let notify = NotificationHandler()
   
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var shelveviewModel: ShelvesviewModel
    
    // individual name, frequency, and time
    @State var medicineName: String = ""
    @State var reminderFrequency: String = ""
    @State var timeOfDay: Date = Date()
    
    // alerts
    @State var alertTitle: String = ""
    @State var showAlert: Bool = false
    
    
    // example
    
   
    
    
    let reminderFrequencies = ["Daily", "Weekdays", "Weekends", "Biweekly","Monthly"]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("creme").ignoresSafeArea()
                
                VStack {
                    
                    VStack {
                        
                        HStack {
                            
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Label("", systemImage: "house").foregroundColor(.black)
                            }
                            
                            Spacer().frame(width: 300)
                        }
                        

                    }
                    
                    Spacer().frame(height: 90)
                    
                   
                    
                    Text("Add New Medicine").font(.custom(FontsManager.Avenir.heavy, size: 35)).fontWeight(.semibold)
                    
                    Rectangle().frame(width: 200, height: 2).foregroundColor(.black)
                    
                    
                    
                    VStack {
                        
                        
                        Form {
                                Section(header: Text("Medicine Name").foregroundColor(Color("darknavy"))) {
                                    TextField("", text: $medicineName)
                                        .textFieldStyle(TransparentTextFieldStyle())
                                }.listRowBackground(hidden())

                            Section(header: Text("Reminder").foregroundColor(Color("darknavy"))) {
                                Picker("Frequency", selection: $reminderFrequency) {
                                    ForEach(reminderFrequencies, id: \.self) { frequency in
                                        Text(frequency)
                                    }
                                }
                                    DatePicker(selection: $timeOfDay, displayedComponents: .hourAndMinute) {
                                        Text("Time").datePickerStyle(.compact)
                                            .labelsHidden()
                                    
                                    
                                }
                            }.listRowBackground(hidden())
                             
                            
                            
                                
                            Section {
                                Button(action: saveReminder) {
                                    // Button action
                                    
                                    
                                    
                                    Text("            Save              ")
                                        .font(.custom(FontsManager.Avenir.heavy, size: 30))
                                        .fontWeight(.bold)
                                        .foregroundColor(Color("creme"))
                                        .padding()
                                        .background(Color("lightnavy"))
                                        .cornerRadius(40)
                                }.listRowBackground(hidden())
                                }.frame(maxWidth: .infinity)}
                            
                            
                    }.scrollContentBackground(.hidden)
                    
                        .alert(isPresented: $showAlert, content: getAlert)
                    
                }
                
            }
            
            
        }
        
    }
    
    func saveReminder() {
        //add validation
        if validateInput() {
            shelveviewModel.addItem(name: medicineName, freq: reminderFrequency, time: timeOfDay)
            
            notify.sendNotification(time: timeOfDay, freq: reminderFrequency, type: "time", title: medicineName, body: "It's time to take your medicine!")
            
            
            
            presentationMode.wrappedValue.dismiss()
        }
        
    }
    func getAlert() -> Alert {
        return Alert(title: Text(alertTitle))
    }
    func validateInput() -> Bool {
            if medicineName.count < 1 {
                // Show an error alert or update UI to indicate an error
               alertTitle = "Your medicine name must be at least 1 character."
                showAlert.toggle()
                return false
            }
            
            if reminderFrequency.isEmpty {
                // Show an error alert or update UI to indicate an error
                alertTitle = "Please pick a frequency."
                 showAlert.toggle()
                return false
            }
            
            if timeOfDay == Date() {
                // Show an error alert or update UI to indicate an error
                alertTitle = "Please pick a time."
                 showAlert.toggle()
                return false
            }
            
            // Perform additional validation checks if needed
            
            return true
        }
    func saveNotificationCount(_ count: Int) {
        UserDefaults.standard.set(count, forKey: "NotificationCountKey")
    }

    func loadNotificationCount() -> Int {
        return UserDefaults.standard.integer(forKey: "NotificationCountKey")
    }
    
    struct AddmedicineView_Previews: PreviewProvider {
    
        static var previews: some View {
            AddmedicineView().environmentObject(ShelvesviewModel()).environmentObject(UserSettings())
            
        }
    }
}
