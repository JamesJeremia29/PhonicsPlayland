//
//  ContentView.swift
//  PhonicsPlayland
//
//  Created by James Jeremia on 08/04/23.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    
    @State private var capturedImage : UIImage? = nil
    
    @State private var isCustomCameraViewPresented = false
    
    var classifier = ObjectClassifier()
    
    
    var body: some View {
        ZStack{
            if capturedImage != nil {
                Image(uiImage: capturedImage!)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            } else{
                Color(UIColor.systemBackground)
            }
            
            VStack{
                Spacer()
                Button (action:{
                    isCustomCameraViewPresented.toggle()
                }, label: {
                    Image(systemName: "camera.fill")
                        .font(.largeTitle)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                })
                .padding(.bottom)
                .sheet(isPresented: $isCustomCameraViewPresented, content:{ CustomCameraView(capturedImage: $capturedImage)})

            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
