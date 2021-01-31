//
//  UISlider+RX.swift
//  MyTunes
//
//  Created by Archil on 1/30/21.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UISlider {
    
    public var dragStarted: ControlProperty<Float> {
        return base.rx.controlProperty(editingEvents: .valueChanged,
            getter: { slider in
                slider.value
            }, setter: { slider, value in
                slider.value = value
            }
        )
    }
    
    public var dragFinnished: ControlProperty<Float> {
        return base.rx.controlProperty(editingEvents: .touchUpInside,
            getter: { slider in
                slider.value
            }, setter: { slider, value in
                slider.value = value
            }
        )
    }
    
}
