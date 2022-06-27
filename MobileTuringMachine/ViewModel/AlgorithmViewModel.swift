//
//  AlgorithmViewModel2.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 27.06.2022.
//

import SwiftUI

class AlgorithmViewModel: ObservableObject {
    
    @Published var algorithms: [Algorithm] = []
    
    let dataManager = DataManager.shared
    
    required init() {
        
        if dataManager.isEmpty() {
            print("Setting default data...")
            addAlgorithm(isDefault: true)
            dataManager.applyChanges()
        } else {
            print("Loading saved data...")
            dataManager.getAlgorithms()
        }
        
        algorithms = dataManager.savedAlgorithms
    }
}

extension AlgorithmViewModel {
    
    func updateName(with newName: String, for algorithm: Algorithm) {
        if newName.isEmpty {
            algorithm.name = "New Algorithm"
            return
        }
        algorithm.name = newName
        dataManager.applyChanges()
    }
    
    func updateDescription(with newDescription: String, for algorithm: Algorithm) {
        algorithm.algorithmDescription = newDescription
        dataManager.applyChanges()
    }
    
    func updateAllTapesComponents(for algorithm: Algorithm) {
        for tape in algorithm.wrappedTapes {
            updateComponents(for: tape)
            tape.headIndex = 0
        }
        dataManager.applyChanges()
    }
    
    func getStartStateName(of algorithm: Algorithm) -> StateQ? {
        algorithm.wrappedStates.first(where: { $0.isStarting })
    }
    
    func reset(algorithm: Algorithm) {
        updateAllTapesComponents(for: algorithm)
        for state in algorithm.wrappedStates {
            state.isStarting = state.isForReset
        }
        dataManager.applyChanges()
    }
    
    func makeStep(algorithm: Algorithm) {
        
        var combination: [String] = []
        
        // Gathering the components that are under tapes' head index
        for tape in algorithm.wrappedTapes {
            guard let component = tape.wrappedComponents.first(where: { $0.id == tape.headIndex }) else {
                print("Error finding component equals to tape head index")
                return
            }
            combination.append(component.value)
        }
        
        // Finding starting state
        guard let startState = algorithm.wrappedStates.first(where: { $0.isStarting }) else {
            print("Error getting start state")
            return
        }
        
        // Finding needed option in state
        guard let currentOption = startState.wrappedOptions.first(where: { $0.wrappedCombinations.map { $0.character } == combination }) else {
            print("Error finding current option")
            return
        }
        
        for index in 0..<combination.count {
            let currentTape = algorithm.wrappedTapes[index]
            guard let component = currentTape.wrappedComponents.first(where: { $0.id == currentTape.headIndex }) else {
                print("Error finding component")
                return
            }
            
            DispatchQueue.main.async {
                component.value = currentOption.wrappedCombinations[index].toCharacter
            }
            switch currentOption.wrappedCombinations[index].directionID {
                
            case 0:
                break
            case 1:
                DispatchQueue.main.async {
                    currentTape.headIndex -= 1
                }
            default:
                DispatchQueue.main.async {
                    currentTape.headIndex += 1
                }
            }
        }
        
        // Setting new start state
        DispatchQueue.main.async {
            startState.isStarting.toggle()
            guard let toState = algorithm.wrappedStates.first(where: { $0.id == currentOption.toStateID }) else {
                print("Error. Couldnt find toState.")
                return
            }
            toState.isStarting.toggle()
        }
    }
    
}

// MARK: - Tape
extension AlgorithmViewModel {
    func changeHeadIndex(to component: TapeComponent) {
        component.tape.headIndex = component.id
        dataManager.applyChanges()
    }
    
    func setNewAlphabet(_ text: String, tape: Tape) {
        tape.alphabet = text
        updateStates(for: tape.algorithm)
        dataManager.applyChanges()
    }
    
    func setNewInput(_ text: String, tape: Tape) {
        tape.input = text
        
        updateComponents(for: tape)
        dataManager.applyChanges()
    }
    
    private func updateStates(for algorithm: Algorithm) {
        for state in algorithm.wrappedStates {
            state.options = []
            addOptions(state: state)
        }
        dataManager.applyChanges()
    }
}

// MARK: - State
extension AlgorithmViewModel {
    func changeStartState(to state: StateQ) {
        guard let currentStartingState = state.algorithm.wrappedStates.first(where: { $0.isStarting } ) else {
            print("Error finding current starting state")
            return
        }
        currentStartingState.isStarting.toggle()
        currentStartingState.isForReset.toggle()
        
        state.isStarting.toggle()
        state.isForReset.toggle()
        
        dataManager.applyChanges()
    }
}

// MARK: - Option
extension AlgorithmViewModel {
    func updateOptionToState(option: Option, currentState: StateQ) {
        option.toStateID = currentState.id
        dataManager.applyChanges()
    }
    
    func isChosenToState(option: Option, currentState: StateQ) -> Bool {
        option.toStateID == currentState.id
    }
    
    func getToStateName(for option: Option) -> Int {
        Int(option.state.algorithm.wrappedStates.first(where: { $0.id == option.toStateID })?.nameID ?? -1)
    }
    
}

// MARK: - Combination
extension AlgorithmViewModel {
    func updateCombinationToChar(combination: Combination, alphabetElement: String) {
        combination.toCharacter = alphabetElement
        dataManager.applyChanges()
    }
    
    func updateCombinationDirection(combination: Combination, directionID: Int) {
        combination.directionID = Int16(directionID)
        dataManager.applyChanges()
    }
    
    func isChosenChar(combination: Combination, alphabetElement: String) -> Bool {
        combination.toCharacter == alphabetElement
    }
    
    func isChosenDirection(combination: Combination, directionID: Int) -> Bool {
        combination.directionID == Int16(directionID)
    }
}


// Working with data
extension AlgorithmViewModel {
    
    func addAlgorithm(isDefault: Bool = false) {
        let algorithm = Algorithm(context: dataManager.container.viewContext)
        algorithm.initValues(states: [], tapes: [])
        addTape(algorithm: algorithm)
        addState(algorithm: algorithm)
        
        algorithms.append(algorithm)
        dataManager.applyChanges()
    }
    
    func deleteAlgorithm(_ algorithm: Algorithm) {
        dataManager.container.viewContext.delete(algorithm)
        algorithms.removeAll { $0.id == algorithm.id }
        dataManager.applyChanges()
    }
    
    func addTape(algorithm: Algorithm) {
        if algorithm.wrappedTapes.isEmpty {
            let tape = Tape(context: dataManager.container.viewContext)
            tape.initValues(nameID: 0, components: [], algorithm: algorithm)
            addComponent(tape: tape)
            algorithm.addToTapes(tape)
            dataManager.applyChanges()
            return
        }
        // Getting the name
        let nameIDArray = algorithm.wrappedTapes.map { $0.nameID }
        guard let max = nameIDArray.max() else {
            print("aboba 3")
            return
        }
        let fullArray = Array(0...max)
        let arrayOfDifferentElements = fullArray.filter { !nameIDArray.contains($0) }
        
        let tape = Tape(context: dataManager.container.viewContext)
        
        if let firstElement = arrayOfDifferentElements.first {
            // In case there ARE gaps between name ids
            tape.initValues(nameID: Int(firstElement), components: [], algorithm: algorithm)
        } else {
            // In case there ARE NO gaps between name ids
            guard let endElement = algorithm.wrappedTapes.last else {
                print("aboba 4")
                return
            }
            tape.initValues(nameID: Int(endElement.nameID + 1), components: [], algorithm: algorithm)
        }
        addComponent(tape: tape)
        algorithm.addToTapes(tape)
        dataManager.applyChanges()
    }
    
    func deleteTape(_ tape: Tape) {
        tape.algorithm.removeFromTapes(tape)
        dataManager.container.viewContext.delete(tape)
        algorithms.removeAll { $0.id == tape.id }
        dataManager.applyChanges()
    }
    
    func addComponent(tape: Tape) {
        for index in -10...10 {
            let component = TapeComponent(context: dataManager.container.viewContext)
            component.initValues(id: index, tape: tape)
            tape.addToComponents(component)
        }
        dataManager.applyChanges()
    }
    
    func updateComponents(for tape: Tape) {
        // Reseting old components
        tape.components = []
        addComponent(tape: tape)
        
        // Update values according to input
        for characterID in 0..<tape.input.count {
            for componentObject in tape.components {
                if let component = componentObject as? TapeComponent {
                    if component.id == Int16(characterID) {
                        component.value = tape.input.map { String($0) }[characterID]
                    }
                }
            }
        }
        dataManager.applyChanges()
    }
    
    func addState(algorithm: Algorithm, isDefault: Bool = false) {
        if algorithm.wrappedStates.isEmpty {
            let state = StateQ(context: dataManager.container.viewContext)
            state.initValues(
                nameID: 0,
                isStarting: isDefault, isForReset: isDefault,
                options: [], algorithm: algorithm
            )
            addOptions(state: state)
            algorithm.addToStates(state)
            dataManager.applyChanges()
            return
        }
        
        // Getting the name
        let nameIDArray = algorithm.wrappedStates.map { $0.nameID }
        guard let max = nameIDArray.max() else {
            print("aboba 1")
            return
        }
        let fullArray = Array(0...max)
        let arrayOfDifferentElements = fullArray.filter { !nameIDArray.contains($0) }
        
        let state = StateQ(context: dataManager.container.viewContext)
        
        if let firstElement = arrayOfDifferentElements.first {
            // In case there ARE gaps between name ids
            state.initValues(
                nameID: Int(firstElement),
                isStarting: isDefault, isForReset: isDefault,
                options: [], algorithm: algorithm
            )
        } else {
            // In case there ARE NO gaps between name ids
            guard let endElement = algorithm.wrappedTapes.last else {
                print("aboba 2")
                return
            }
            state.initValues(
                nameID: Int(endElement.nameID + 1),
                isStarting: isDefault, isForReset: isDefault,
                options: [], algorithm: algorithm
            )
        }
        addOptions(state: state)
        algorithm.addToStates(state)
        dataManager.applyChanges()
    }
    
    func deleteState(_ state: StateQ) {
        if state.isStarting {
            if state.nameID == 0 {
                updateStartState(state: state, id: 1)
            } else {
                updateStartState(state: state, id: 0)
            }
        }
        
        state.algorithm.removeFromStates(state)
        dataManager.container.viewContext.delete(state)
        dataManager.applyChanges()
    }
    
    private func updateStartState(state: StateQ, id: Int) {
        state.isStarting.toggle()
        for element in state.algorithm.states {
            if let state = element as? StateQ {
                if state.nameID == Int16(id) {
                    state.isStarting.toggle()
                    break
                }
            }
        }
        dataManager.applyChanges()
    }
    
    func addOptions(state: StateQ) {
        var alphabets: [[String]] = []
        for tape in state.algorithm.wrappedTapes {
            var tapeAlphabet = tape.alphabet.map { String($0) }
            tapeAlphabet.append("_")
            alphabets.append(tapeAlphabet)
        }
        var combinations: [[String]] = []
        getCombinations(array: alphabets, word: [], currentArrayIndex: 0, result: &combinations)
        
        for combinationIndex in 0..<combinations.count {
            let option = Option(context: dataManager.container.viewContext)
            option.initValues(id: combinationIndex, toStateID: state.id, combinations: [], state: state)
            addCombinations(combinations: combinations[combinationIndex], option: option)
            state.addToOptions(option)
        }
        dataManager.applyChanges()
    }
    
    func addCombinations(combinations: [String], option: Option) {
        for combinationIndex in 0..<combinations.count {
            let combination = Combination(context: dataManager.container.viewContext)
            combination.initValues(id: combinationIndex, character: combinations[combinationIndex], directionID: 0, option: option)
            option.addToCombinations(combination)
        }
        dataManager.applyChanges()
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
}
