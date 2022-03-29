//
//  ListenButton.swift
//  envsoundclassifier
//
//  Created by Simone Giordano on 29/03/22.
//

import SwiftUI

struct ListenButton: View {
    @State var isActive: Bool = false
    var streamManager: AudioStreamManager
    var body: some View {
        Circle()
            .frame(width: 150, height: 150)
            .foregroundColor(isActive ? .red : .gray)
            .onTapGesture {
                isActive.toggle()
                isActive ? streamManager.installTap() : streamManager.removeTap()
            }
            .shadow(radius: 5.0)
            
    }
}

struct ListenButton_Previews: PreviewProvider {
    static var manager = AudioStreamManager()
    static var previews: some View {
        ListenButton(streamManager: manager)
    }
}
