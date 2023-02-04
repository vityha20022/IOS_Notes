//
//  NotesModel.swift
//  Notes
//
//  Created by Виктор Борисовский on 03.02.2023.
//

import Foundation

let notesDataKey = "notesData"
var notesList: [(noteHeader: String, noteBody: String)] {
    get {
        guard let notesData = UserDefaults.standard.array(forKey: notesDataKey) as? [(String, String)] else {
            return [("Go to shop", "I shoul'd go to shop")]
        }

        return notesData
    }

    set {
        UserDefaults.standard.set(newValue, forKey: notesDataKey)
        UserDefaults.standard.synchronize()
    }
}

func addNote(noteHeader: String, noteBody: String) {
    notesList.append((noteHeader, noteBody))
}

func removeNote(at index: Int) {
    notesList.remove(at: index)
}

func moveNote(fromIndex: Int, toIndex: Int) {
    let fromNote = notesList[fromIndex]
    notesList.remove(at: fromIndex)

    notesList.insert(fromNote, at: toIndex)
}
