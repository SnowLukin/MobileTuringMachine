//
//  TapeContentViewModel.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 13.03.2022.
//

import Foundation

class TapeContentViewModel: ObservableObject {
    @Published var tapes: [Tape] = Data().tapes
    @Published var states: [StateQ] = [Data.startState]
    @Published var stateForReset: StateQ = Data.startState
    
    let tapesKey: String = "tapes_data_key"
    
    required init() {
        if let storedTapes = DataManager.shared.getStorage(for: tapesKey) {
            tapes = storedTapes
        } else {
            
        }
    }
}

// MARK: - States
extension TapeContentViewModel {
    
    // MARK: Add
    func addState() {
        // Getting the name
        let nameIDArray = states.map { $0.nameID }
        guard let max = nameIDArray.max() else { return }
        let fullArray = Array(0...max)
        
        let arrayOfDifferentElements = fullArray.filter { !nameIDArray.contains($0) }
        
        if let firstElement = arrayOfDifferentElements.first {
            // In case there ARE gaps between name ids
            var newState = StateQ(nameID: firstElement, options: [])
            newState.options = getOptions(for: newState)
            if let indexToInsert = nameIDArray.firstIndex(where: { firstElement < $0 }) {
                states.insert(newState, at: indexToInsert)
            } else {
                // Shouldn't happen
                states.append(newState)
            }
        } else {
            // In case there ARE NO gaps between name ids
            guard let endElement = states.last else { return }
            var newState = StateQ(nameID: endElement.nameID + 1, options: [])
            newState.options = getOptions(for: newState)
            states.append(newState)
        }
    }
    
    // MARK: Remove
    func removeState(state: StateQ) {
        if let stateIndex = states.firstIndex(where: { $0.id == state.id }) {
            // if state that is being deleted is a starting state
            // before deleting we need to set different statring state
            if states[stateIndex].isStarting {
                if stateIndex == 0 {
                    changeStartState(to: states[1])
                } else {
                    changeStartState(to: states[0])
                }
            }
            states.remove(at: stateIndex)
        }
    }
    
    // MARK: Update
    func updateStates() {
        for index in 0..<states.count {
            states[index].options = getOptions(for: states[index])
        }
    }
    
    private func getCombinationsTuple(combinations: [String]) -> [Combination] {
        var combinationsTuple: [Combination] = []
        for combination in combinations {
            combinationsTuple.append(Combination(character: combination, direction: .stay, toCharacter: combination))
        }
        return combinationsTuple
    }
    
    private func getCombinations(array: [[String]], word: [String], currentArrayIndex: Int, result: inout [[String]]) {
        if currentArrayIndex == array.count {
            result.append(word)
        } else {
            for element in array[currentArrayIndex] {
                var newWord = word
                newWord.append(element)
                getCombinations(array: array, word: newWord, currentArrayIndex: currentArrayIndex + 1, result: &result)
            }
        }
    }
    
    func getOptions(for state: StateQ) -> [Option] {
        var alphabets: [[String]] = []
        for tape in tapes {
            var tapeAlphabet = tape.alphabet.map { String($0) }
            tapeAlphabet.append("_")
            alphabets.append(tapeAlphabet)
        }
        var combinations: [[String]] = []
        getCombinations(array: alphabets, word: [], currentArrayIndex: 0, result: &combinations)
        
        var optionStates: [Option] = []
        for combinationIndex in 0..<combinations.count {
            optionStates.append(
                Option(
                    toState: state,
                    combinations: getCombinationsTuple(combinations: combinations[combinationIndex])
                )
            )
        }
        return optionStates
    }
}


// MARK: - Tape
extension TapeContentViewModel {
    
    // MARK: Change head index
    func changeHeadIndex(of tape: Tape, to component: TapeContent) {
        if let tapeIndex = tapes.firstIndex(where: { $0.id == tape.id }) {
            tapes[tapeIndex].headIndex = component.id
        }
    }
    
    // MARK: Add
    func addTape() {
        
        // Getting the name
        let nameIDArray = tapes.map { $0.nameID }
        guard let max = nameIDArray.max() else { return }
        
        let fullArray = Array(0...max)
        
        let arrayOfDifferentElements = fullArray.filter { !nameIDArray.contains($0) }
        if let firstElement = arrayOfDifferentElements.first {
            // In case there ARE gaps between name ids
            let newTape = Tape(nameID: firstElement, components: getComponents())
            if let indexToInsert = nameIDArray.firstIndex(where: { firstElement < $0 }) {
                tapes.insert(newTape, at: indexToInsert)
            } else {
                // Shouldn't happen
                tapes.append(newTape)
            }
        } else {
            // In case there ARE NO gaps between name ids
            guard let endElement = tapes.last else { return }
            tapes.append(Tape(nameID: endElement.nameID + 1, components: getComponents()))
        }
        updateStates()
    }
    
    // MARK: Remove
    func removeTape(tape: Tape) {
        if let index = tapes.firstIndex(where: { $0.id == tape.id }) {
            tapes.remove(at: index)
        }
        updateStates()
    }
    
    // MARK: Alphabet
    func setNewAlphabet(_ text: String, tape: Tape) {
        guard let tapeIndex = tapes.firstIndex(where: { $0.id == tape.id }) else {
            print("viewModel couldnt find tape index for setNewAlphabet function")
            return
        }
        // Update alphabet
        tapes[tapeIndex].alphabet = text
        updateStates()
    }
    
    // MARK: Input
    func setNewInput(_ text: String, tape: Tape) {
        guard let tapeIndex = tapes.firstIndex(where: { $0.id == tape.id }) else {
            print("viewModel couldnt find tape index for setNewInput function")
            return
        }
        
        // Update input
        tapes[tapeIndex].input = text
        
        updateComponents(tape: tape)
    }
    
    func updateComponents(tape: Tape) {
        guard let tapeIndex = tapes.firstIndex(where: { $0.id == tape.id }) else {
            print("viewModel couldnt find tape index for setNewInput function")
            return
        }
        
        // Reset values
        for componentIndex in 0..<tapes[tapeIndex].components.count {
            tapes[tapeIndex].components[componentIndex].value = "_"
        }
        
        // Update values according to input
        for characterID in 0..<tapes[tapeIndex].input.count {
            if let componentIndex = tapes[tapeIndex].components.firstIndex(where: { $0.id == characterID }) {
                tapes[tapeIndex].components[componentIndex].value = tapes[tapeIndex].input.map { String($0) }[characterID]
            }
        }
    }
    
    func updateAllTapesComponents() {
        for tapeIndex in 0..<tapes.count {
            updateComponents(tape: tapes[tapeIndex])
            tapes[tapeIndex].headIndex = 0
        }
    }
    
    // MARK: Components
    func getComponents() -> [TapeContent] {
        var components: [TapeContent] = []
        for index in -10...10 {
            components.append(
                TapeContent(
                    id: index,
                    value: "_"
                )
            )
        }
        return components
    }
}

// MARK: - ChooseStateView
extension TapeContentViewModel {
    func updateOptionToState(state: StateQ, option: Option, currentState: StateQ) {
        guard let stateIndex = states.firstIndex(where: { $0.id == state.id }) else { return }
        guard let optionIndex = states[stateIndex].options.firstIndex(where: { $0.id == option.id }) else { return }
        states[stateIndex].options[optionIndex].toState = currentState
    }
    
    func isChosenToState(state: StateQ, option: Option, currentState: StateQ) -> Bool {
        guard let stateIndex = states.firstIndex(where: { $0.id == state.id }) else { return false }
        guard let optionIndex = states[stateIndex].options.firstIndex(where: { $0.id == option.id }) else { return false }
        return states[stateIndex].options[optionIndex].toState.id == currentState.id
    }
}

// MARK: - CombinationView
extension TapeContentViewModel {
    func getMatchingTape(state: StateQ, option: Option, combination: Combination) -> Tape {
        guard let stateIndex = states.firstIndex(where: { $0.id == state.id }) else { return tapes[0] }
        guard let optionIndex = states[stateIndex].options.firstIndex(where: { $0.id == option.id }) else { return tapes[0] }
        guard let combinationIndex = states[stateIndex].options[optionIndex].combinations.firstIndex(
            where: { $0.id == combination.id }
        ) else { return tapes[0] }
        return tapes[combinationIndex]
    }
    
    func getOptionToState(state: StateQ, option: Option) -> Int {
        guard let stateIndex = states.firstIndex(where: { $0.id == state.id }) else { return 0 }
        guard let optionIndex = states[stateIndex].options.firstIndex(where: { $0.id == option.id }) else { return 0 }
        return states[stateIndex].options[optionIndex].toState.nameID
    }
}

extension TapeContentViewModel {
    
    func getCombination(state: StateQ, option: Option, combination: Combination) -> Combination? {
        guard let stateIndex = states.firstIndex(where: { $0.id == state.id }) else { return nil }
        guard let optionIndex = states[stateIndex].options.firstIndex(
            where: { $0.id == option.id }
        ) else { return nil }
        guard let combinationIndex = states[stateIndex].options[optionIndex].combinations.firstIndex(
            where: { $0.id == combination.id }
        ) else { return nil }
        
        return states[stateIndex].options[optionIndex].combinations[combinationIndex]
    }
    
    func updateCombinationToChar(state: StateQ, option: Option, combination: Combination, alphabetElement: String) {
        guard let stateIndex = states.firstIndex(where: { $0.id == state.id }) else { return }
        guard let optionIndex = states[stateIndex].options.firstIndex(
            where: { $0.id == option.id }
        ) else { return }
        guard let combinationIndex = states[stateIndex].options[optionIndex].combinations.firstIndex(
            where: { $0.id == combination.id }
        ) else { return }
        
        states[stateIndex].options[optionIndex].combinations[combinationIndex].toCharacter = alphabetElement
    }
    
    func updateCombinationDirection(state: StateQ, option: Option, combination: Combination, direction: Direction) {
        guard let stateIndex = states.firstIndex(where: { $0.id == state.id }) else { return }
        guard let optionIndex = states[stateIndex].options.firstIndex(
            where: { $0.id == option.id }
        ) else { return }
        guard let combinationIndex = states[stateIndex].options[optionIndex].combinations.firstIndex(
            where: { $0.id == combination.id }
        ) else { return }
        
        states[stateIndex].options[optionIndex].combinations[combinationIndex].direction = direction
    }
    
    func isChosenChar(state: StateQ, option: Option, tape: Tape, combination: Combination, alphabetElement: String) -> Bool {
        guard let stateIndex = states.firstIndex(where: { $0.id == state.id }) else { return false }
        guard let optionIndex = states[stateIndex].options.firstIndex(
            where: { $0.id == option.id }
        ) else { return false }
        guard let tapeIndex = tapes.firstIndex(where: { $0.id == tape.id }) else { return false }
        guard let combinationIndex = states[stateIndex].options[optionIndex].combinations.firstIndex(
            where: { $0.id == combination.id }
        ) else { return false}
        
        guard let alphabetElementIndex = tapes[tapeIndex].alphabetArray.firstIndex(where: { $0 == alphabetElement}) else { return false }
        
        return states[stateIndex].options[optionIndex].combinations[combinationIndex].toCharacter == tapes[tapeIndex].alphabetArray[alphabetElementIndex]
    }
    
    func isChosenDirection(state: StateQ, option: Option, tape: Tape, combination: Combination, direction: Direction) -> Bool {
        guard let stateIndex = states.firstIndex(where: { $0.id == state.id }) else { return false }
        guard let optionIndex = states[stateIndex].options.firstIndex(
            where: { $0.id == option.id }
        ) else { return false }
        guard let combinationIndex = states[stateIndex].options[optionIndex].combinations.firstIndex(
            where: { $0.id == combination.id }
        ) else { return false}
        
        return states[stateIndex].options[optionIndex].combinations[combinationIndex].direction == direction
    }
}

// MARK: - Tape View
extension TapeContentViewModel {
    
    func getTape(tape: Tape) -> Tape {
        guard let tapeIndex = tapes.firstIndex(where: { $0.id == tape.id }) else {
            return tapes[0]
        }
        return tapes[tapeIndex]
    }
    
    func getTapeComponent(tape: Tape, component: TapeContent) -> TapeContent {
        let currentTape = getTape(tape: tape)
        guard let componentIndex = currentTape.components.firstIndex(where: { $0.id == component.id }) else {
            return currentTape.components[0]
        }
        return currentTape.components[componentIndex]
    }
    
    func getStartState() -> StateQ {
        guard let startStateIndex = states.firstIndex(where: { $0.isStarting }) else {
            print("Error. Couldnt find start state: TapeContentViewModel, line 337")
            return states[0]
        }
        return states[startStateIndex]
    }
    
    func changeStartState(to state: StateQ) {
        guard let startStateIndex = states.firstIndex(where: { $0.isStarting }) else {
            print("Error. Couldnt find start state")
            return
        }
        states[startStateIndex].isStarting.toggle()
        guard let newStartStateIndex = states.firstIndex(where: { $0.id == state.id }) else { return }
        states[newStartStateIndex].isStarting.toggle()
        stateForReset = states[newStartStateIndex]
    }
}


// MARK: - Magic
extension TapeContentViewModel {
    
    func reset() {
        updateAllTapesComponents()
        for stateIndex in 0..<states.count {
            states[stateIndex].isStarting = false
        }
        guard let startStateIndex = states.firstIndex(where: { $0.id == stateForReset.id }) else {
            print("Error. Couldnt find startStateIndex for reset. TapeContentViewModel, line 365")
            return
        }
        states[startStateIndex].isStarting.toggle()
    }
    
    func makeStep() {
        var combination: [String] = []
        
        // Gathering the components that are under tapes' head index
        for tape in tapes {
            if let componentIndex = tape.components.firstIndex(where: { $0.id == tape.headIndex }) {
                combination.append(tape.components[componentIndex].value)
            }
        }
        
        // Finding index of starting state
        guard let startStateIndex = states.firstIndex(where: { $0.isStarting }) else {
            print("Error. Couldnt find start state index: TapeContentViewModel, line 383")
            return
        }
        
        // Finding needed option in state
        guard let optionCombination = states[startStateIndex].options.first(where: { $0.combinations.map { $0.character } == combination }) else {
            print("Error. Couldnt find optionCombination")
            return
        }
        
        for index in 0..<combination.count {
            guard let componentIndex = tapes[index].components.firstIndex(where: { $0.id == tapes[index].headIndex }) else { return }
            DispatchQueue.main.async {
                self.tapes[index].components[componentIndex].value = optionCombination.combinations[index].toCharacter
            }
            switch optionCombination.combinations[index].direction {
                
            case .stay:
                break
            case .left:
                DispatchQueue.main.async {
                    self.tapes[index].headIndex -= 1
                }
            case .right:
                DispatchQueue.main.async {
                    self.tapes[index].headIndex += 1
                }
            }
        }
        
        // Setting new start state
        DispatchQueue.main.async {
            self.states[startStateIndex].isStarting.toggle()
            guard let toStateIndex = self.states.firstIndex(where: { $0.id == optionCombination.toState.id }) else {
                print("Error. Couldnt find index of toState.")
                return
            }
            self.states[toStateIndex].isStarting.toggle()
        }
    }
    
}
