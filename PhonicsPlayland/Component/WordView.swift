//
//  WordView.swift
//  PhonicsPlayland
//
//  Created by James Jeremia on 09/04/23.
//

import SwiftUI
import Foundation

struct WordView: View {
    //    @ObservedObject var classifier: ImageClassifier
    @State var characterLoopIndex: Int = -1
    let loopDuration: Double = 1
    var str1 : String = "hello"
    
    var body: some View {
        VStack(alignment: .center){
//            Spacer().padding(.bottom)
            HStack{
                var myArr = Array(str1).map(String.init)
                ForEach(myArr.indices) { index in
                    Spacer().padding(.leading)
                    Text("\(myArr[index])")
                        .font(.system(size: 43, weight: .bold))
                        .scaledToFit()
                        .opacity(characterLoopIndex >= index ? 1 : 0)
                        .animation(.linear(duration: loopDuration))
                    Spacer().padding(.trailing)
                }
                .onAppear(perform: {startCharacterAnimation()})
            }.padding(.all)
//            Spacer().padding(.bottom)
        }
    }
    //    func decodeWord()->[String]{
    //        var chars: [String] = []
    //        if let imageClass = classifier.imageClass{
    //            let chars = Array(imageClass).map(String.init)
    //            return chars
    ////            for char in chars {
    ////                let value = char.description
    ////                print(type(of: value))
    ////                return value
    ////            }
    //        }
    //        return chars
    //    }
    
    func startCharacterAnimation() {
        var myArr = Array(str1).map(String.init)
        let timer = Timer.scheduledTimer(withTimeInterval: loopDuration, repeats: true) { (timer) in
            
            characterLoopIndex += 1
            if characterLoopIndex >= myArr.count {
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
struct WordView_Previews: PreviewProvider {
    static var previews: some View {
        WordView()
    }
}
