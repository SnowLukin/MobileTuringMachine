//
//  AlgorithmViewModel2.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 27.06.2022.
//

import SwiftUI

class AlgorithmViewModel: ObservableObject {
    
    let dataManager = DataManager.shared
    
    required init() {
        if dataManager.isEmpty() {
            print("Setting default data...")
            addFolder(name: "Algorithms")
            dataManager.applyChanges()
        } else {
            print("Loading saved data...")
            dataManager.getFolders()
        }
    }
}

extension AlgorithmViewModel {
    func addFolder(name: String, parentFolder: Folder? = nil) {
        let folder = Folder(context: dataManager.container.viewContext)
        folder.initValues(name: name)
        
        objectWillChange.send()
        dataManager.applyChanges()
    }
    
    func deleteFolder(_ folder: Folder) {
        dataManager.container.viewContext.delete(folder)
        objectWillChange.send()
        dataManager.applyChanges()
    }
    
    func updateName(with newName: String, for algorithm: Algorithm) {
        if newName.isEmpty {
            algorithm.name = "New Algorithm"
        } else {
            algorithm.name = newName
        }
        
        algorithm.editedDate = Date.now
        dataManager.applyChanges()
        objectWillChange.send()
    }
    
    func updateDescription(with newDescription: String, for algorithm: Algorithm) {
        algorithm.algorithmDescription = newDescription
        
        algorithm.editedDate = Date.now
        dataManager.applyChanges()
        objectWillChange.send()
    }
    
    func updateAllTapesComponents(for algorithm: Algorithm) {
        for tape in algorithm.wrappedTapes {
            updateComponents(for: tape)
            tape.headIndex = 0
        }
        
        algorithm.editedDate = Date.now
        dataManager.applyChanges()
        objectWillChange.send()
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
        objectWillChange.send()
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
        objectWillChange.send()
        // Setting new start state
        DispatchQueue.main.async {
            startState.isStarting.toggle()
            guard let toState = algorithm.wrappedStates.first(where: { $0.id == currentOption.toStateID }) else {
                print("Error. Couldnt find toState.")
                return
            }
            toState.isStarting.toggle()
            self.objectWillChange.send()
        }
    }
    
}

// MARK: - Tape
extension AlgorithmViewModel {
    func changeHeadIndex(to component: TapeComponent) {
        component.tape.headIndex = component.id
        
        component.tape.algorithm.editedDate = Date.now
        objectWillChange.send()
        dataManager.applyChanges()
    }
    
    func setNewInputValue(_ text: String, for tape: Tape) {
        var text = text
        
        // Return if nothin changed
        if tape.input == text {
            return
        }
        
        // Poping last element if possible.
        guard let lastCharacter = text.popLast() else {
            // If not possible -> text is empty.
            updateInput(text, for: tape)
            return
        }
        
        // if new character is "space" change it to "_"
        if lastCharacter == " " {
            text.append("_")
            updateInput(text, for: tape)
            return
        }
        // if there is such character in alphabet - save it
        // otherwise delete it
        if tape.alphabet.contains(lastCharacter) {
            text.append(lastCharacter)
        }
        updateInput(text, for: tape)
    }
    
    private func removeInputCharactersWhichAreNotInAlphabet(for tape: Tape) {
        let filteredInput = tape.input.filter { tape.alphabet.contains($0)}
        updateInput(filteredInput, for: tape)
    }
    
    func setNewAlphabetValue(_ text: String, for tape: Tape) {
        var text = text
        // Return if nothin changed
        if tape.alphabet == text {
            return
        }
        // Poping last element if possible.
        guard let lastCharacter = text.popLast() else {
            // If not possible -> text is empty.
            updateAlphabet(text, for: tape)
            removeInputCharactersWhichAreNotInAlphabet(for: tape)
            return
        }
        // If last character is a "space". Remove it.
        if lastCharacter == " " {
            return
        }  else if !text.contains(lastCharacter) {  // Checking new character already exist
            // if it isn't - add it
            text.append(String(lastCharacter))
            updateAlphabet(text, for: tape)
            removeInputCharactersWhichAreNotInAlphabet(for: tape)
        }
    }
    
    private func updateAlphabet(_ text: String, for tape: Tape) {
        tape.alphabet = text
        updateStates(for: tape.algorithm)
        
        tape.algorithm.editedDate = Date.now
        objectWillChange.send()
        dataManager.applyChanges()
    }
    
    private func updateInput(_ text: String, for tape: Tape) {
        tape.input = text
        updateComponents(for: tape)
        
        tape.algorithm.editedDate = Date.now
        objectWillChange.send()
        dataManager.applyChanges()
    }
    
    private func updateStates(for algorithm: Algorithm) {
        for state in algorithm.wrappedStates {
            for option in state.wrappedOptions {
                state.removeFromOptions(option)
                dataManager.container.viewContext.delete(option)
            }
            let combinations = getPossibleCombinations(for: state)
            addOptions(to: state, combinations: combinations)
        }
        
        algorithm.editedDate = Date.now
        objectWillChange.send()
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
        
        state.algorithm.editedDate = Date.now
        objectWillChange.send()
        dataManager.applyChanges()
    }
}

// MARK: - Option
extension AlgorithmViewModel {
    func updateOptionToState(option: Option, currentState: StateQ) {
        guard let id = currentState.id else {
            print("Error getting current state's id")
            return
        }
        option.toStateID = id
        
        option.state.algorithm.editedDate = Date.now
        objectWillChange.send()
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
        
        combination.option.state.algorithm.editedDate = Date.now
        objectWillChange.send()
        dataManager.applyChanges()
    }
    
    func updateCombinationDirection(combination: Combination, directionID: Int) {
        combination.directionID = Int16(directionID)
        
        combination.option.state.algorithm.editedDate = Date.now
        objectWillChange.send()
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
    
    func addAlgorithm(to folder: Folder) {
        let algorithm = Algorithm(context: dataManager.container.viewContext)
        algorithm.initValues(folder: folder, states: [], tapes: [])
        addTape(algorithm: algorithm)
        addState(algorithm: algorithm)
        
        folder.addToAlgorithms(algorithm)
        objectWillChange.send()
        dataManager.applyChanges()
    }
    
    func deleteAlgorithm(_ algorithm: Algorithm) {
        algorithm.folder.removeFromAlgorithms(algorithm)
        dataManager.container.viewContext.delete(algorithm)
        objectWillChange.send()
        dataManager.applyChanges()
    }
    
    func addTape(algorithm: Algorithm) {
        if algorithm.wrappedTapes.isEmpty {
            let tape = Tape(context: dataManager.container.viewContext)
            tape.initValues(nameID: 0, components: [], algorithm: algorithm)
            addComponent(tape: tape)
            algorithm.addToTapes(tape)
            
            algorithm.editedDate = Date.now
            objectWillChange.send()
            dataManager.applyChanges()
            return
        }
        // Getting the name
        let nameIDArray = algorithm.wrappedTapes.map { $0.nameID }
        guard let max = nameIDArray.max() else {
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
                return
            }
            tape.initValues(nameID: Int(endElement.nameID + 1), components: [], algorithm: algorithm)
        }
        addComponent(tape: tape)
        algorithm.addToTapes(tape)
        updateStates(for: algorithm)
        
        algorithm.editedDate = Date.now
        objectWillChange.send()
        dataManager.applyChanges()
    }
    
    func deleteTape(_ tape: Tape) {
        tape.algorithm.removeFromTapes(tape)
        dataManager.container.viewContext.delete(tape)
        updateStates(for: tape.algorithm)
        objectWillChange.send()
        dataManager.applyChanges()
    }
    
    func addComponent(tape: Tape) {
        for index in -10...10 {
            let component = TapeComponent(context: dataManager.container.viewContext)
            component.initValues(id: index, tape: tape)
            tape.addToComponents(component)
        }
        objectWillChange.send()
        dataManager.applyChanges()
    }
    
    func updateComponents(for tape: Tape) {
        // Update components values according to input
        for component in tape.wrappedComponents {
            if (0..<tape.input.count).contains(Int(component.id)) {
                component.value = tape.input.map { String($0) }[Int(component.id)]
            } else {
                component.value = "_"
            }
        }
        
        objectWillChange.send()
        dataManager.applyChanges()
    }
    
    func addState(algorithm: Algorithm) {
        if algorithm.wrappedStates.isEmpty {
            let state = StateQ(context: dataManager.container.viewContext)
            state.initValues(
                id: UUID(),
                nameID: 0,
                isStarting: true, isForReset: true,
                options: [], algorithm: algorithm
            )
            let combinations = getPossibleCombinations(for: state)
            addOptions(to: state, combinations: combinations)
            algorithm.addToStates(state)
            
            algorithm.editedDate = Date.now
            objectWillChange.send()
            dataManager.applyChanges()
            return
        }
        
        // Getting the name
        let nameIDArray = algorithm.wrappedStates.map { $0.nameID }
        guard let max = nameIDArray.max() else {
            return
        }
        let fullArray = Array(0...max)
        let arrayOfDifferentElements = fullArray.filter { !nameIDArray.contains($0) }
        
        let state = StateQ(context: dataManager.container.viewContext)
        
        if let firstElement = arrayOfDifferentElements.first {
            // In case there ARE gaps between name ids
            state.initValues(id: UUID(), nameID: Int(firstElement), options: [], algorithm: algorithm)
        } else {
            // In case there ARE NO gaps between name ids
            guard let endElement = algorithm.wrappedStates.last else {
                return
            }
            state.initValues(id: UUID(), nameID: Int(endElement.nameID + 1), options: [], algorithm: algorithm)
        }
        let combinations = getPossibleCombinations(for: state)
        addOptions(to: state, combinations: combinations)
        algorithm.addToStates(state)
        
        algorithm.editedDate = Date.now
        objectWillChange.send()
        dataManager.applyChanges()
    }
    
    func deleteState(_ state: StateQ) {
        objectWillChange.send()
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
        state.algorithm.wrappedStates.first(where: { $0.nameID == Int16(id) })?.isStarting.toggle()
        
        state.algorithm.editedDate = Date.now
        objectWillChange.send()
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
    
    func getTapesAlphabets(of algorithm: Algorithm) -> [[String]] {
        var alphabets: [[String]] = []
        for tape in algorithm.wrappedTapes {
            var tapeAlphabet = tape.alphabet.map { String($0) }
            tapeAlphabet.append("_")
            alphabets.append(tapeAlphabet)
        }
        return alphabets
    }
    
    func getPossibleCombinations(for state: StateQ) -> [[String]] {
        let alphabets: [[String]] = getTapesAlphabets(of: state.algorithm)
        var combinations: [[String]] = []
        getCombinations(array: alphabets, word: [], currentArrayIndex: 0, result: &combinations)
        return combinations
    }
}

extension AlgorithmViewModel {
    
    func addOptions(to state: StateQ, combinations: [[String]]) {
        for combinationIndex in 0..<combinations.count {
            let option = Option(context: dataManager.container.viewContext)
            option.initValues(id: combinationIndex, toStateID: state.id!, combinations: [], state: state)
            addCombinations(combinations: combinations[combinationIndex], option: option)
            state.addToOptions(option)
        }
        objectWillChange.send()
        dataManager.applyChanges()
    }
    
    func addCombinations(combinations: [String], option: Option) {
        for combinationIndex in 0..<combinations.count {
            let combination = Combination(context: dataManager.container.viewContext)
            combination.initValues(id: combinationIndex, character: combinations[combinationIndex], directionID: 0, option: option)
            option.addToCombinations(combination)
        }
        dataManager.applyChanges()
        objectWillChange.send()
    }
    
    func getSearchResult(_ searchText: String, sorting: Sortings, sortingOrder: SortingOrder, folder: Folder) -> [Algorithm] {
        let filteredAlgorithms = getSearchedAlgorithms(searchText, folder: folder)
        switch sorting {
        case .name:
            return filteredAlgorithms
                .sorted(by: { sortingOrder == .up ? $0.name < $1.name : $0.name > $1.name })
        case .dateCreated:
            return filteredAlgorithms.sorted(by: {
                sortingOrder == .up
                ? $0.wrappedCreationDate < $1.wrappedCreationDate
                : $0.wrappedCreationDate > $1.wrappedCreationDate
            })
        case .dateEdited:
            return filteredAlgorithms.sorted(by: {
                sortingOrder == .up
                ? $0.wrappedEditedDate < $1.wrappedEditedDate
                : $0.wrappedEditedDate > $1.wrappedEditedDate
            })
        }
    }
    
    private func getSearchedAlgorithms(_ searchText: String, folder: Folder) -> [Algorithm] {
        searchText.isEmpty
        ? folder.wrappedAlgorithms
        : folder.wrappedAlgorithms.filter { $0.name.contains(searchText) }
    }
    
    func getAlgorithmEditedTimeForTextView(_ algorithm: Algorithm) -> String {
        if Calendar.current.isDateInYesterday(algorithm.wrappedEditedDate) {
            return "Yesterday"
        }
        
        let formatter = DateFormatter()
        if Calendar.current.isDateInToday(algorithm.wrappedEditedDate) {
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: algorithm.wrappedEditedDate)
        }
        formatter.dateFormat = "d MMM y"
        return formatter.string(from: algorithm.wrappedEditedDate)
    }
}
