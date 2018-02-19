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
        
        client.upcomingMoviesForPage(page: 1)
            .observeOn(MainScheduler.instance)
            .catchError({ (error) -> Observable<[Movie]> in
                print(error)
                return Observable.just([])
            })
            .subscribe({ (event) in
                self.movies = event.element
                print(self.movies)
            })
            .disposed(by: disposeBag)
        
    }

}

