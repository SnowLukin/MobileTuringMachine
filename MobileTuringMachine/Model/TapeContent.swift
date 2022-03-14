//
//  TapeContent.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 13.03.2022.
//

import Foundation

struct TapeContent: Identifiable {
    let id: Int
    var value = "_"
}

//extension TapeContent {
//    static func getTapeContents() -> [TapeContent] {
//        var tapeContents: [TapeContent] = []
//        
//        for index in -256...256 {
//            tapeContents.append(TapeContent(id: index))
//        }
//        return tapeContents
//    }
//}
