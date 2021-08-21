//
//  ViewModel.swift
//  WillBeBack
//
//  Created by Antonio Favata on 21/08/2021.
//

import Foundation

final class ViewModel {
    private let key = "awayMessage"
    private let defaults = UserDefaults.standard

    let defaultMessage = "I will be back in"

    private var initial = 0
    private var current = 0
    private var timer: Timer?

    private(set) var time = ""

    var tick: (() -> Void)?

    var isTicking: Bool { timer != nil }

    init() {
        defaults.register(defaults: [key: defaultMessage])
    }

    var awayMessage: String? {
        get { defaults.string(forKey: key) }
        set {
            if let message = newValue, !message.isEmpty {
                defaults.setValue(message, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }

    func update() {
        let hours = current / 3600
        let minutes = (current - hours * 3600) / 60
        let seconds = current % 60
        if hours > 0 {
            time = String(format: "%dh%02d'", hours, minutes)
        } else {
            time = String(format: "%d'%02d\"", minutes, seconds)
        }
        tick?()
    }

    func changeTime(_ deltaMinutes: Int) {
        let newValue = initial + deltaMinutes * 60
        initial = max(0, min(newValue, 24 * 3600))
        current = initial
        update()
        startTimer()
    }

    func startTimer() {
        timer?.invalidate()
        timer = .scheduledTimer(withTimeInterval: 1, repeats: true) { [unowned self] _ in
            self.update()
            if self.current > 0 {
                self.current -= 1
            } else {
                self.timer?.invalidate()
                self.timer = nil
            }
        }
    }

    func reset() {
        timer?.invalidate()
        timer = nil
        initial = 0
        current = 0
        update()
    }
}
