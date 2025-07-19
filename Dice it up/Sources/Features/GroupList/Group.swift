//
//  Group.swift
//  Dice it up
//
//  Created by The Real Itto on 16/07/2025.
//
import Foundation

// A group represents one group of player the dm is playing with.
struct Group : Identifiable, Equatable {
    // Unique id used to avoid confusion while handling lists.
    let id : UUID
    // The group's name.
    let name : String
    // The group url's last part
    // used with : https://rolz.org/api/roomlog?room=
    let urlPart : String
}
