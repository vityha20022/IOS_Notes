//
//  NoteViewController.swift
//  Notes
//
//  Created by Виктор Борисовский on 04.02.2023.
//

import UIKit

class NoteViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var noteTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextView.delegate = self
        noteTextView.text = "dsfsdfsdfsd\n\nfsdfsdfsdfds\nffdfdfd\nfsdfdsf\n\nfwefewfewfrgt"
        makeHeaderBold()
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneEditingClicked))
        self.navigationItem.rightBarButtonItem = doneButton
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        self.navigationItem.rightBarButtonItem = nil
    }

    @objc func doneEditingClicked() {
        noteTextView.resignFirstResponder()
    }

    func textViewDidChange(_ textView: UITextView) {
        makeHeaderBold()
    }

    func textViewDidChangeSelection(_ textView: UITextView) {
        makeHeaderBold()
    }

    func makeHeaderBold() {
        let selectedRange = noteTextView.selectedRange
        let noteText = noteTextView.text! as NSString
        let noteComponents = noteText.components(separatedBy: "\n")

        let firstNoteString = noteComponents[0]

        let attributedText = NSMutableAttributedString(attributedString: noteTextView.attributedText!)

        var boldTextRange = noteText.range(of: firstNoteString)
        if boldTextRange.length == 0 {
            boldTextRange = NSRange(0...0)
        }
        attributedText.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 30.0), range: boldTextRange)

        let smallTextRange = boldTextRange.length > 0 ? NSRange(boldTextRange.upperBound..<noteText.length) : NSRange(0..<noteText.length)
        attributedText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 17.0), range: smallTextRange)

        noteTextView.attributedText = attributedText
        noteTextView.selectedRange = selectedRange
    }
}
