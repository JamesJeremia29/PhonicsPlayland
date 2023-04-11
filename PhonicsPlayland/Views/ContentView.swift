//
//  ContentView.swift
//  PhonicsPlayland
//
//  Created by James Jeremia on 08/04/23.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    
    @StateObject private var model = ContentViewModel()
    var classifier = ObjectClassifier()
    
    
    var body: some View {
        FrameView(image: model.frame)
          .edgesIgnoringSafeArea(.all)

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
