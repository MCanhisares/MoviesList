//
//  ViewController.swift
//  MoviesList
//
//  Created by Marcel Canhisares on 17/02/18.
//  Copyright © 2018 Azell. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    var movies: [Movie]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupBindings()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    private func setupBindings() {
        let client = APIClient.MovieAPIClient()
        
        let obs = client.movieDetailWithId(id:701)
            .observeOn(MainScheduler.instance)
            .subscribe({ (event) in
                print(event.element)
            })
            .disposed(by: disposeBag)
        
    }

}

