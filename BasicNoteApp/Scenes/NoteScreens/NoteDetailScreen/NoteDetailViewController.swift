//
//  NoteDetailViewController.swift
//  BasicNoteApp
//
//  Created by Metehan Veliashvili on 11.07.2024.
//

import UIKit

class NoteDetailViewController: UIViewController {
    
    // MARK: - UI COMPONENTS
    
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var noteTextView: UITextView!
    
    // MARK: - VARIABLES
    var noteID: Int?
    var accessToken: String?
    
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
        guard let token = accessToken else {
            print("Access Token is Missing!")
            return
        }
        
        guard let title = titleTextView.text else {
            print("Geçerli bir başlık girilmedi!")
            return
        }
        
        guard let note = noteTextView.text else {
            print("Geçerli bir not girilmedi!")
            return
        }
        
        let createNoteRequest = PostCreateNoteRequest(title: title, note: note, access_token: token)
        
        dataProvider.request(request: createNoteRequest) { result in
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
