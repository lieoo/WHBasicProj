//
//  LotteryZoneDetailTableViewCell.m
//  WHBasicProj
//
//  Created by 行政 on 17/4/28.
//  Copyright © 2017年 lieo. All rights reserved.
//

#import "LotteryZoneDetailTableViewCell.h"

@implementation LotteryZoneDetailTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat leftmargin = 16;
        CGFloat topmargin = 5;
        CGFloat labelH = 20;
        _expectLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftmargin, topmargin, 150, labelH)];
        _expectLabel.textColor = [UIColor redColor];
        _expectLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_expectLabel];
        
        _opentime = [[UILabel alloc]initWithFrame:CGRectMake(170, topmargin, DEVICEWIDTH/2-30, labelH)];
        _opentime.font = [UIFont systemFontOfSize:14];
        _opentime.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_opentime];
        
        _opencode = [[UILabel alloc]initWithFrame:CGRectMake(leftmargin, labelH+10, DEVICEWIDTH - (leftmargin * 2), 40)];
        _opencode.textAlignment = NSTextAlignmentCenter;
        _opencode.adjustsFontSizeToFitWidth = YES;

        _opencode.font = [UIFont systemFontOfSize:30];
        [self.contentView addSubview:_opencode];
    }
    return self;
}
@end
