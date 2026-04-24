//
//  AddCoinsToPortfolioViewModel.swift
//  ScreenEx
//
//  Created by Anastasia on 15.04.2026.
//

import Foundation
import Combine
import CoreData

@MainActor
class AddCoinsToPortfolioViewModel: ObservableObject {
	
	@Published var CoinsID: [(String, Double)] = []
	@Published var coins: [Coins] = []
	
	init() {}
	
	func addCoin(id: String, count: Double, context: NSManagedObjectContext) {
		let checkRequest: NSFetchRequest<Coins> = Coins.fetchRequest()
		checkRequest.predicate = NSPredicate(format: "name == %@", id)
		checkRequest.fetchLimit = 1
		
		do {
			let exist = try context.count(for: checkRequest) > 0
			guard !exist else { return }
			
			let newCoin = Coins(context: context)
			newCoin.name = id
			newCoin.count = NSDecimalNumber(value: count)
			
			try context.save()
			fetchCoinsFromCoreData(context: context)
		} catch {
			print("[ AddCoinsToPortfolioViewModel ] error here \(error)")
		}
	}
	
	func deleteCoin(id: String, context: NSManagedObjectContext) {
		let request: NSFetchRequest<Coins> = Coins.fetchRequest()
		request.predicate = NSPredicate(format: "name == %@", id)
		
		do {
			let coinsToDelete = try context.fetch(request)
			for coin in coinsToDelete {
				context.delete(coin)
			}
			
			try context.save()
			fetchCoinsFromCoreData(context: context)
		} catch {
			print("[ AddCoinsToPortfolioViewModel ] error here \(error.localizedDescription)")
		}
	}
	
	func fetchCoinsFromCoreData(context: NSManagedObjectContext) {
		let request: NSFetchRequest<Coins> = Coins.fetchRequest()
		request.sortDescriptors = [NSSortDescriptor(keyPath: \Coins.name, ascending: true)]
		
		do {
			coins = try context.fetch(request)
		} catch {
			print("[ AddCoinsToPortfolioViewModel ] error here \(error)")
		}
		
		rewriteCoins(coins)
	}
	
	func rewriteCoins(_ coins: [Coins]) {
			self.coins = coins
			self.CoinsID = coins.map { coin in
				(coin.name ?? "", coin.count?.doubleValue ?? 0)
			}
		
			self.CoinsID.sort { $0.0 < $1.0 }
		}
}
