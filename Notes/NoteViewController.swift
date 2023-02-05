//
//  NoteViewController.swift
//  Notes
//
//  Created by Виктор Борисовский on 04.02.2023.
//

import UIKit

class NoteViewController: UIViewController, UITextViewDelegate, UITextPasteDelegate {
    @IBOutlet weak var noteTextView: UITextView!

    var noteText: String!
    var cellIndex: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextView.delegate = self
        noteTextView.pasteDelegate = self
        noteTextView.text = noteText
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

    func textPasteConfigurationSupporting(_ textPasteConfigurationSupporting: UITextPasteConfigurationSupporting,
                                          performPasteOf attributedString: NSAttributedString, to textRange: UITextRange) -> UITextRange {
        if let textView = textPasteConfigurationSupporting as? UITextView {
            let pasteBoard = UIPasteboard.general
            if pasteBoard.hasStrings {
                guard let pasteString = pasteBoard.string else {
                    return textRange
                }

                textView.insertText(pasteString)

                DispatchQueue.main.async {
                    if let selectedRange = textView.selectedTextRange {
                        // only if the new position is valid
                        if let newPosition = textView.position(from: selectedRange.start, offset: pasteString.count) {
                            // set the new position
                            textView.selectedTextRange = textView.textRange(from: newPosition, to: newPosition)
                        }
                    }
                }
            }
        }

        return textRange
    }

    func makeHeaderBold() {
        let selectedRange = noteTextView.selectedRange
        let noteNSText = noteTextView.text! as NSString
        let noteComponents = noteNSText.components(separatedBy: "\n")

        let firstNoteString = noteComponents[0]

        let attributedText = NSMutableAttributedString(attributedString: noteTextView.attributedText!)

        if attributedText.length == 0 {
            return
        }

        var boldTextRange = noteNSText.range(of: firstNoteString)
        if boldTextRange.length == 0 {
            boldTextRange = NSRange(0...0)
        }
        attributedText.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 30.0), range: boldTextRange)

        let smallTextRange = boldTextRange.length > 0 ? NSRange(boldTextRange.upperBound..<noteNSText.length) : NSRange(0..<noteNSText.length)

        attributedText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 17.0), range: smallTextRange)

        noteTextView.attributedText = attributedText
        noteTextView.selectedRange = selectedRange
    }

}
