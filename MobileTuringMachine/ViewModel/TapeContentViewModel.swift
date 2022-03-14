//
//  TapeContentViewModel.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 13.03.2022.
//

import Foundation

class TapeContentViewModel: ObservableObject {
    
    @Published var amountOfTapes = 1
    @Published var currentIndex = 0
    @Published var tapes: [Tape] = [Tape(id: 0)]
}

extension TapeContentViewModel {
    
    // In case of manual need to set tapes
//    func setTapes(_ amount: Int) {
//        tapes.removeAll()
//        for id in 0..<amount {
//            tapes.append(Tape(id: id))
//        }
//    }
    
    func addTape() {
        amountOfTapes += 1
        tapes.append(Tape(id: amountOfTapes - 1))
    }
    
    func removeTape(id: Int) {
        amountOfTapes -= 1
        tapes.remove(at: id)
        
        // Rewriting IDs
        for index in 0..<amountOfTapes {
            tapes[index].id = index
        }
    }
    
    func changeCurrentIndex(to index: Int) {
        currentIndex = index
    }
    
    func isTapeContentSelected(_ tapeContent: TapeContent) -> Bool {
        tapeContent.id == currentIndex
    }
    
    func setNewAlphabet(_ text: String, id: Int) {
        tapes[id].alphabet = text
    }
    
    func setNewInput(_ text: String, id: Int) {
        tapes[id].input = text
    }
    
}
