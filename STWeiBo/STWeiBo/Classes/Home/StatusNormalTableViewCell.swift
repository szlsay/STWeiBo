//
//  StatusNormalTableViewCell.swift
//  STWeiBo
//
//  Created by ST on 15/11/17.
//  Copyright © 2015年 ST. All rights reserved.
//

import UIKit

class StatusNormalTableViewCell: StatusTableViewCell {

    
    override func setupUI() {
        super.setupUI()
        
        let cons = pictureView.ST_AlignVertical(type: ST_AlignType.BottomLeft, referView: contentLabel, size: CGSizeZero, offset: CGPoint(x: 0, y: 10))
        
        pictureWidthCons = pictureView.ST_Constraint(cons, attribute: NSLayoutAttribute.Width)
        pictureHeightCons =  pictureView.ST_Constraint(cons, attribute: NSLayoutAttribute.Height)

    }
}
