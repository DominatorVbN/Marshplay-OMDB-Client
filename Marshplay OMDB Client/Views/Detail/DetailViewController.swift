//
//  DetailViewController.swift
//  Marshplay OMDB Client
//
//  Created by dominator on 08/01/20.
//  Copyright © 2020 dominator. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var foreGroundImageView: UIImageView!
    @IBOutlet weak var recordTitleLabel: UILabel!
    @IBOutlet weak var recordYearLabel: UILabel!
    @IBOutlet weak var recordTypeLabel: UILabel!
    
    var record: Record!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backgroundImageView.downloadImageFrom(link: record.poster, contentMode: .scaleAspectFill)
        self.foreGroundImageView.downloadImageFrom(link: record.poster, contentMode: .scaleAspectFit)
            
        self.recordTitleLabel.text = record.title
        self.recordYearLabel.text = record.year
        self.recordTypeLabel.text = record.type
    }

}
