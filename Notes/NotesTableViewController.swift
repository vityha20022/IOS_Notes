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
        /*let noteAddingController = UIAlertController(title: "Create new note", message: "", preferredStyle: .alert)
        noteAddingController.addTextField { textField in
            textField.placeholder = "New note..."
        }

        let createAction = UIAlertAction(title: "Create", style: .cancel) { _ in
            let newNote = noteAddingController.textFields![0].text
            addNote(noteName: newNote!)
            self.tableView.reloadData()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .default)

        noteAddingController.addAction(createAction)
        noteAddingController.addAction(cancelAction)

        present(noteAddingController, animated: true)*/
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

        cell.noteHeaderTextField.text = notesList[indexPath.row].noteHeader
        cell.noteBodyTextField.text = notesList[indexPath.row].noteBody

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            removeNote(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        moveNote(fromIndex: fromIndexPath.row, toIndex: to.row)
        tableView.reloadData()
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
