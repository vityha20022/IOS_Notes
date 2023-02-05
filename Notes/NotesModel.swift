//
//  NotesModel.swift
//  Notes
//
//  Created by Виктор Борисовский on 03.02.2023.
//

import Foundation

struct Note: Codable {
    var header: String
    var body: String
}

let notesDataKey = "notesData"
var notesList: [Note] {
    get {
        guard let decodedNotesData = UserDefaults.standard.data(forKey: notesDataKey) else {
            return [Note(header: "Go to shop", body: "I shoul'd go to shop")]
        }

        let encodedNotesData = try! PropertyListDecoder().decode([Note].self, from: decodedNotesData)

        return encodedNotesData
    }

    set {
        let encodedNote = try! PropertyListEncoder().encode(newValue)
        UserDefaults.standard.set(encodedNote, forKey: notesDataKey)
        UserDefaults.standard.synchronize()
    }
}

func getNote(at index: Int) -> Note {
    return notesList[index]
}

func addNote(noteHeader: String, noteBody: String) {
    notesList.append(Note(header: noteHeader, body: noteBody))
}

func editNote(at index: Int, noteHeader: String, noteBody: String) {
    notesList[index].header = noteHeader
    notesList[index].body = noteBody
}

func removeNote(at index: Int) {
    notesList.remove(at: index)
}

func moveNote(fromIndex: Int, toIndex: Int) {
    let fromNote = notesList[fromIndex]
    notesList.remove(at: fromIndex)

    notesList.insert(fromNote, at: toIndex)
}
