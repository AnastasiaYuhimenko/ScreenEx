//
//  PersistenceController.swift
//  ScreenEx
//
//  Created by Anastasia on 24.04.2026.
//

import CoreData

struct PersistenceController {
	static let shared = PersistenceController()
	
	let container: NSPersistentContainer
	
	init() {
		container = NSPersistentContainer(name: "Portfolio")
		container.loadPersistentStores { _, error in
			if let error = error {
				print("[PersistenceController] error here \(error.localizedDescription)")
			}
		}
		container.viewContext.automaticallyMergesChangesFromParent = true
	}
	
}
