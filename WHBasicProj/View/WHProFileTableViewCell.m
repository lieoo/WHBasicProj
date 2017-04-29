//
//  WHProFileTableViewCell.m
//  WHBasicProj
//
//  Created by 行政 on 17/4/29.
//  Copyright © 2017年 lieo. All rights reserved.
//

#import "WHProFileTableViewCell.h"

@implementation WHProFileTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _headImage = [[UIImageView alloc]initWithFrame:CGRectMake(30, 30, 25, 25)];
        [self.contentView addSubview:_headImage];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 30, DEVICEWIDTH, 30)];
        [self.contentView addSubview:_nameLabel];
        
    }
    return self;
}

@end
