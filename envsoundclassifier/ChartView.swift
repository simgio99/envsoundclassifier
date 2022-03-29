//
//  ChartView.swift
//  envsoundclassifier
//
//  Created by Simone Giordano on 29/03/22.
//

import SwiftUI

struct ChartView: View {
    @ObservedObject var observer: AudioStreamObserver
    var body: some View {
        HStack(alignment: .bottom) {
            ForEach(0..<observer.topResults.count, id: \.self) { index in
                RoundedRectangle(cornerRadius: 2.0)
                    
                    .frame(height: 250 * observer.topResults[index].confidence)
            }
        }
        
        .fixedSize()
        .frame(height: 250)
    }
}



struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(observer: AudioStreamObserver())
    }
}
