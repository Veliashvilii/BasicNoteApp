//
//  NoteListViewController.swift
//  BasicNoteApp
//
//  Created by Metehan Veliashvili on 11.07.2024.
//

import UIKit

class NoteListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UI Elements
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var searchBarView: UISearchBar!
    
    // MARK: - Variables
    var accessToken: String?
    var noteID: Int?
    var notes: [Note] = []
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = searchBarView
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notes.removeAll()
        tableView.reloadData()
        getMyNotes()
    }
    
    // MARK: - Actions
    @IBAction func addNoteButtonTapped(_ sender: UIButton) {
        changeScreenToDetail(row: nil)
    }
    @IBAction func profileButtonTapped(_ sender: UIButton) {
        let router = Router()
        router.viewController = self
        
        let pushTransition = PushTransition()
        router.open("Profile", "ProfileViewController", transition: pushTransition, extraParams: ["access_token": self.accessToken ?? "Gelmiyor"])
    }
    // MARK: - Public Methods
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        print("Search Text: \(String(describing: searchText))")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 124
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = notes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath)
        cell.textLabel?.text = note.title
        cell.detailTextLabel?.text = note.note
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        changeScreenToDetail(row: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (action, view, completionHandler) in
            
            guard let token = self.accessToken else { return }
            let noteID = self.notes[indexPath.row].noteID
            
            self.deleteNote(indexPath: indexPath, noteID: noteID, token: token)
            completionHandler(true)
        }
        deleteAction.image = UIImage(named: "ic_trash")
        deleteAction.backgroundColor = UIColor(red: 221/255.0, green: 44/255.0, blue: 0/255.0, alpha: 1.0)
               
        let editAction = UIContextualAction(style: .normal, title: nil) { (action, view, completionHandler) in
            
            guard let token = self.accessToken else { return }
            let router = Router()
            router.viewController = self
            let pushTransition = PushTransition()
            
            router.open("EditNote", "EditNoteViewController", transition: pushTransition, extraParams: ["noteID": self.notes[indexPath.row].noteID, "access_token": token])
            completionHandler(true)
        }
        editAction.image = UIImage(named: "ic_edit")
        editAction.backgroundColor = UIColor(red: 255/255, green: 209/255, blue: 100/255, alpha: 1.0)

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
               
        return configuration
    }

    // GETNOTES: - PRIVATE FUNCTIONS
    
    private func getMyNotes(page: Int = 1) {
        guard let token = accessToken else {
            print("Access token is missing")
            return
        }
        
        let getMyNotesRequest = GetMyNotesRequest(access_token: token, page: page)
        
        dataProvider.request(request: getMyNotesRequest) { result in
            switch result {
            case .success(let response):
                print("Request succeeded with response: \(response)")
                if let notesData = response.data {
                    if let fetchedNotes = notesData.data {
                        self.notes.append(contentsOf: fetchedNotes.map { Note(noteID: $0.id ?? 0, title: $0.title ?? "", note: $0.note ?? "") })
                                               
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
                        if notesData.current_page ?? page < notesData.last_page ?? page {
                            // Daha fazla sayfa varsa, sonraki sayfayı getirmek için. Tam olarak doğru mantık mı biraz kafam karıştı bi sormalı bunu!
                            self.getMyNotes(page: page + 1)
                        }
                    } else {
                        print("No notes found")
                    }
                } else {
                    print("Data is missing in the response")
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    private func deleteNote(indexPath: IndexPath, noteID: Int, token: String) {
        let deleteRequest = DeleteNoteRequest(id: noteID, access_token: token)
        
        dataProvider.request(request: deleteRequest) { result in
            switch result {
            case .success(let response):
                if let message = response.message {
                    self.notes.remove(at: indexPath.row)
                    DispatchQueue.main.async {
                        self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                    print("Message: \(message)")
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }

    
    // MARK: - Router Function
    
    func changeScreenToDetail(row: Int?) {
        guard let token = accessToken else {
            print("Access token is missing")
            return
        }
        
        let router = Router()
        router.viewController = self
        
        let pushTransition = PushTransition()
        if let row = row {
            router.open("EditNote", "EditNoteViewController", transition: pushTransition, extraParams: ["noteID": notes[row].noteID, "access_token": token])
        } else {
            router.open("NoteDetail", "NoteDetailViewController", transition: pushTransition, extraParams: ["access_token": token])
        }
    }
    
}
