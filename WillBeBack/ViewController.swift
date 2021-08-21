//
//  ViewController.swift
//  WillBeBack
//
//  Created by Antonio Favata on 20/08/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var topButton: UIButton!
    @IBOutlet var timeLabel: UILabel!

    private let viewModel = ViewModel()

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .landscape
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        topButton.setTitle(viewModel.awayMessage, for: .normal)
        topButton.titleLabel?.minimumScaleFactor = 0.5
        topButton.titleLabel?.adjustsFontSizeToFitWidth = true

        viewModel.tick = { [weak self] in
            self?.timeLabel.text = self?.viewModel.time
        }
    }

    // MARK: IBActions

    @IBAction func buttonPressed(_ sender: Any) {
        if viewModel.isTicking {
            viewModel.reset()
        } else {
            let alert = UIAlertController(title: "Set your away message", message: nil, preferredStyle: .alert)
            alert.addTextField {
                $0.text = self.viewModel.awayMessage
                $0.placeholder = self.viewModel.defaultMessage
            }
            alert.addAction(.init(title: "OK", style: .default) { [weak self] _ in
                self?.viewModel.awayMessage = alert.textFields?.first?.text
                self?.topButton.setTitle(self?.viewModel.awayMessage, for: .normal)
            })
            alert.addAction(.init(title: "Cancel", style: .cancel))
            present(alert, animated: true)
        }
    }

    @IBAction func decreaseTime(_ sender: Any) {
        viewModel.changeTime(-5)
    }

    @IBAction func increaseTime(_ sender: Any) {
        viewModel.changeTime(5)
    }
}
