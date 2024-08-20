//
//  EditNoteViewController.swift
//  BasicNoteApp
//
//  Created by Metehan Veliashvili on 11.07.2024.
//

import UIKit

class EditNoteViewController: UIViewController {
    // MARK: - VARIABLES
    var noteID: Int?
    var accessToken: String?
    
    // MARK: - UI COMPONENTS
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var noteTextView: UITextView!
    
    // MARK: - LIFECYLE METHODS
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getNote()
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func getNote() {
        guard let noteID = noteID else {
            print("Note ID is missing!")
            return
        }
        
        guard let token = accessToken else {
            print("Access Token is missing!")
            return
        }
        
        let getNoteRequest = GetNoteRequest(id: noteID, access_token: token)
        
        dataProvider.request(request: getNoteRequest) { result in
            switch result {
            case .success(let response):
                print("Request succeeded with response: \(response)")
                if let noteData = response.data {
                    DispatchQueue.main.async {
                        self.titleTextView.text = noteData.title
                        self.noteTextView.text = noteData.note
                    }
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    // MARK: - ACTIONS
    
    @IBAction func saveNoteButtonTapped(_ sender: UIButton) {
        guard let id = noteID else {
            print("Note ID is Missing")
            return
        }
        
        guard let token = accessToken else {
            print("Access Token is Missing")
            return
        }
        
        guard let title = titleTextView.text else {
            print("No Title!")
            return
        }
        
        guard let note = noteTextView.text else {
            print("No Note!")
            return
        }
        
        let updateNoteRequest = UpdateNoteRequest(id: id, title: title, note: note, access_token: token)
        
        dataProvider.request(request: updateNoteRequest) { result in
            switch result {
            case .success(let response):
                if let message = response.message {
                    print("Message: \(message)")
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
}
