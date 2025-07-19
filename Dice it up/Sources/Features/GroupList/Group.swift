//
//  Group.swift
//  Dice it up
//
//  Created by The Real Itto on 16/07/2025.
//
import Foundation

// Un groupe représente un groupe de joueurs d'une campagne.
struct Group : Identifiable, Equatable {
    // Id unique pour créer une liste sans confusion.
    let id : UUID
    // Nom du groupe.
    let name : String
}
