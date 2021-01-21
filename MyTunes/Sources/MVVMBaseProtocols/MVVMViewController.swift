//
//  MVVMViewController.swift
//  MyTunes
//
//  Created by Archil on 1/20/21.
//

protocol MVVMViewController: class {
    
    associatedtype ViewModelType
    
    var viewModel: ViewModelType! { get set }
    
}
