//
//  Animator.swift
//  BasicNoteApp
//
//  Created by Serkan Erkan on 18.07.2024.
//

import UIKit

protocol Animator: UIViewControllerAnimatedTransitioning {
    var isPresenting: Bool { get set }
}
