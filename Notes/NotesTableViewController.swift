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
        let noteVC = storyboard?.instantiateViewController(withIdentifier: "NoteViewController") as! NoteViewController
        noteVC.noteText = ""
        noteVC.cellIndex = nil
        navigationController?.pushViewController(noteVC, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
            removeNote(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        moveNote(fromIndex: fromIndexPath.row, toIndex: to.row)
        tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let noteVC = segue.destination as! NoteViewController
        noteVC.noteText = ""
    }

    @IBAction func unwindFromNotePage( _ seg: UIStoryboardSegue) {
        let noteVc = seg.source as! NoteViewController
        print("ok")
        guard seg.identifier == "unwindFromNotePage" else {
            return
        }

        let cellIndex = noteVc.cellIndex
        let noteText = noteVc.noteTextView.text!

        if cellIndex == nil { // add new note
            guard !noteText.isEmpty else { // empty note
                return
            }

            notesList.append(Note(header: noteText.getFirstStringOfText(), body: noteText.getAllStringsExceptFirst()))
            print(Note(header: noteText.getFirstStringOfText(), body: noteText.getAllStringsExceptFirst()))
            tableView.reloadData()
        }
    }

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension String {
    func getFirstStringOfText() -> String {
        let noteComponents = self.components(separatedBy: "\n")
        for component in noteComponents {
            if !component.isEmpty {
                return component
            }
        }

        return ""
    }

    func getAllStringsExceptFirst() -> String {
        var noteComponents = self.components(separatedBy: "\n")
        for index in 0..<noteComponents.count {
            if !noteComponents[index].isEmpty {
                noteComponents.remove(at: index)
                break
            }
        }
        return noteComponents.joined(separator: "\n")
    }
}
