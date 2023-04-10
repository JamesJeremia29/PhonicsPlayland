//
//  WordView.swift
//  PhonicsPlayland
//
//  Created by James Jeremia on 09/04/23.
//

import SwiftUI
import Foundation

struct WordView: View {
    @ObservedObject var classifier: ImageClassifier
    @State var characterLoopIndex: Int = -1
        let loopDuration: Double = 0.5
    
    var body: some View {
        HStack{
            ForEach(decodeWord().indices) { index in
                            Text("\(decodeWord()[index])")
                                .opacity(characterLoopIndex >= index ? 1 : 0)
                                .animation(.linear(duration: loopDuration))
                        }
            .onAppear(perform: {startCharacterAnimation()})
        }
    }
    func decodeWord()->[String]{
        var chars: [String] = []
        if let imageClass = classifier.imageClass{
            let chars = Array(imageClass).map(String.init)
            return chars
//            for char in chars {
//                let value = char.description
//                print(type(of: value))
//                return value
//            }
        }
        return chars
    }
    
    func startCharacterAnimation() {
            let timer = Timer.scheduledTimer(withTimeInterval: loopDuration, repeats: true) { (timer) in
                
                characterLoopIndex += 1
                if characterLoopIndex >= decodeWord().count {
                    timer.invalidate()
                }
                
            }
            timer.fire()
        }
}


class ImageClassifier: ObservableObject {
    
    @Published private var classifier = ObjectClassifier()
    
    var imageClass: String? {
        classifier.results
    }
    
    // MARK: Intent(s)
    func detect(uiImage: UIImage) {
        guard let ciImage = CIImage (image: uiImage) else { return }
        classifier.detect(ciImage: ciImage)
        
    }
        
}
//struct WordView_Previews: PreviewProvider {
//    static var previews: some View {
//        WordView()
//    }
//}
