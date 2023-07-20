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
    
    
    @State var item: ItemModel
    @State var editedName: String = ""
    @State var editedFreq: String = ""
    @State var editedTime: Date = Date()
    
    
    let reminderFrequencies = ["Daily", "Weekdays", "Weekends", "Biweekly","Monthly"]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("creme").ignoresSafeArea()
                
                VStack {
                    Text("Edit Medicine").font(.largeTitle).fontWeight(.semibold)
                    
                    Rectangle().frame(width: 200, height: 2).foregroundColor(.black)
                    
                    
                    
                    VStack {
                        
                        
                        Form {
                            Section(header: Text("Medicine Name").foregroundColor(Color("darknavy"))) {
                                TextField("", text: $editedName)
                                    .textFieldStyle(TransparentTextFieldStyle())
                            }.listRowBackground(hidden())
                            
                            Section(header: Text("Reminder").foregroundColor(Color("darknavy"))) {
                                Picker("Frequency", selection: $editedFreq) {
                                    ForEach(reminderFrequencies, id: \.self) { frequency in
                                        Text(frequency)
                                    }
                                }
                                DatePicker(selection: $editedTime, displayedComponents: .hourAndMinute) {
                                    Text("Time").datePickerStyle(.compact)
                                        .labelsHidden()
                                    
                                    
                                }
                            }.listRowBackground(hidden())
                            
                            
                            
                            
                            Section {
                                Button(action: {
                                    saveReminder(item: $item, editedName: editedName, editedFreq: editedFreq, editedTime: editedTime, shelvesviewModel: shelveviewModel)
                                }) {
                                    
                                    
                                    Text("              Save              ")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color("creme"))
                                        .padding()
                                        .background(Color("lightnavy"))
                                        .cornerRadius(40)
                                }.listRowBackground(hidden())
                            }.frame(maxWidth: .infinity)}
                        
                        
                    }.scrollContentBackground(.hidden)
                    
                }
            }
        }
    }
    func saveReminder(item: Binding<ItemModel>, editedName: String, editedFreq: String, editedTime: Date, shelvesviewModel: ShelvesviewModel) {
        
        self.item.name = editedName
        self.item.freq = editedFreq
        self.item.time = editedTime
        
        shelvesviewModel.updateItem(item: item.wrappedValue)
        
        presentationMode.wrappedValue.dismiss()
    }
}



struct EditmedicineView_Previews: PreviewProvider {
    static var item1 = ItemModel(name: "Accutane", freq: "Daily", time: .none, color: .clear)
    
    static var previews: some View {
        
        EditmedicineView(item: item1).environmentObject(ShelvesviewModel())
    }
}
