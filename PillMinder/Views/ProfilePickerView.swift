//
//  ProfilePickerView.swift
//  PillMinder
//
//  Created by Leann Hashishi on 7/25/23.
//

import SwiftUI

struct ProfilePickerView: View {
    var body: some View {
        ZStack {
            Color("creme").ignoresSafeArea()
        }
    }
}

struct ProfilePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePickerView().environmentObject(ShelvesviewModel())
    }
}
