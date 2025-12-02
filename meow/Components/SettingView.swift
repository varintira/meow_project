//
//  SettingView.swift
//  meow
//
//  Created by Warintira Pureprasert on 2/12/2568 BE.
//

import SwiftUI

struct SettingView: View {
    let imageName:String
    let title: String
    let tintColor: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: imageName)
                .imageScale(.small)
                .font(.title)
                .foregroundColor(tintColor)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.black)
        }
    }
}

#Preview {
    SettingView(imageName: "gear", title: "Version", tintColor: Color(.systemGray))
}
