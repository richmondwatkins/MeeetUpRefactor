//
//  MemberViewController.m
//  MeetMeUp
//
//  Created by Dave Krawczyk on 9/8/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "Member.h"
#import "MemberViewController.h"
#import "Member.h"
@interface MemberViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) Member *member;
@end

@implementation MemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.photoImageView.alpha = 0;

    [Member retrieveMembeById:self.memberID withCompletion:^(Member *member) {
        self.member = member;
    }];
}

- (void)setMember:(Member *)member
{
    _member = member;
    self.nameLabel.text = member.name;

    [member downloadUserImage:^(UIImage *image) {
        self.photoImageView.image = image;
        [UIView animateWithDuration:.3 animations:^{
            self.photoImageView.alpha  = 1;
        }];
    }];
}



@end
