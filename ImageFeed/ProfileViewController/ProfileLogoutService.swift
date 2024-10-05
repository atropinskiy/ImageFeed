//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by alex_tr on 05.10.2024.
//

import Foundation
// Обязательный импорт
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    
    
    
    func logout() {
        cleanCookies()
        switchToAuthScreen()
    }
    
    private func cleanCookies() {
        // Очищаем все куки из хранилища
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        // Запрашиваем все данные из локального хранилища
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            // Массив полученных записей удаляем из хранилища
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func switchToAuthScreen() {
        // Получаем текущее окно приложения
        guard let window = UIApplication.shared.windows.first else {
            print("Не удалось получить главное окно.")
            return
        }
        
        // Ищем стартовый Navigation Controller из Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController else {
            print("Не удалось получить Navigation Controller")
            return
        }

        // Устанавливаем Navigation Controller как rootViewController с анимацией
        window.rootViewController = navigationController
        UIView.transition(with: window,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
    }
}
