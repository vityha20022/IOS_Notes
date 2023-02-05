//
//  NotesTableViewController.swift
//  Notes
//
//  Created by Виктор Борисовский on 03.02.2023.
//

import UIKit

class NotesTableViewController: UITableViewController {

    @IBAction func pushEditAction(_ sender: Any) {
        tableView.setEditing(!tableView.isEditing, animated: true)
    }

    @IBAction func pushAddAction(_ sender: Any) {
        showNotePage(noteText: "", cellIndex: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 25)], for: .normal)
        self.navigationController?.tabBarItem.title = createNotesCountString(notesCount: getNotesCount())
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return notesList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteTableViewCell

        cell.noteHeaderTextField.text = notesList[indexPath.row].header
        cell.noteBodyTextField.text = notesList[indexPath.row].body.getFirstStringOfText()

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removeNoteAndUpdateNotesCount(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let note = getNote(at: indexPath.row)
        let noteText = note.header + "\n" + note.body
        showNotePage(noteText: noteText, cellIndex: indexPath)
    }

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        moveNote(fromIndex: fromIndexPath.row, toIndex: to.row)
        tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let noteVC = segue.destination as! NoteViewController
        noteVC.noteText = ""
    }

    func showNotePage(noteText: String, cellIndex: IndexPath?) {
        let noteVC = storyboard?.instantiateViewController(withIdentifier: "NoteViewController") as! NoteViewController
        noteVC.noteText = noteText
        noteVC.cellIndex = cellIndex
        navigationController?.pushViewController(noteVC, animated: true)
    }

    @IBAction func unwindFromNotePage( _ seg: UIStoryboardSegue) {
        self.tabBarController?.tabBar.isHidden = false

        let noteVC = seg.source as! NoteViewController
        guard seg.identifier == "unwindFromNotePage" else {
            return
        }

        let noteText = noteVC.noteTextView.text!

        if let cellIndex = noteVC.cellIndex { // edit note
            guard !noteText.isEmpty else {
                removeNoteAndUpdateNotesCount(at: cellIndex)

                tableView.reloadData()
                return
            }

            editNote(at: cellIndex.row, noteHeader: noteText.getFirstStringOfText(), noteBody: noteText.getAllStringsExceptFirst())
            tableView.reloadData()
        } else {  // add new node
            guard !noteText.isEmpty else { // empty note
                return
            }

            addNoteAndUpdateNotesCount(noteHeader: noteText.getFirstStringOfText(), noteBody: noteText.getAllStringsExceptFirst())
            tableView.reloadData()
        }
    }

    func addNoteAndUpdateNotesCount(noteHeader: String, noteBody: String) {
        addNote(noteHeader: noteHeader, noteBody: noteBody)
        self.navigationController?.tabBarItem.title = createNotesCountString(notesCount: getNotesCount())
    }

    func removeNoteAndUpdateNotesCount(at path: IndexPath) {
        removeNote(at: path.row)
        self.navigationController?.tabBarItem.title = createNotesCountString(notesCount: getNotesCount())
    }

    func createNotesCountString(notesCount: Int) -> String {
        return String(notesCount) + " " + "notes"
    }
}

extension String {
    func getFirstStringOfText() -> String {
        let noteComponents = self.components(separatedBy: "\n")
        for component in noteComponents where !component.isEmpty {
            return component
        }

        return ""
    }

    func getAllStringsExceptFirst() -> String {
        var noteComponents = self.components(separatedBy: "\n")
        for index in 0..<noteComponents.count where !noteComponents[index].isEmpty {
            noteComponents.remove(at: index)
            break
        }
        return noteComponents.joined(separator: "\n")
    }
}
