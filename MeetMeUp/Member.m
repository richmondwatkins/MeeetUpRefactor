//
//  Member.m
//  MeetMeUp
//
//  Created by Dave Krawczyk on 9/8/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "Member.h"

@implementation Member

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.state = dictionary[@"state"];
        self.city = dictionary[@"city"];
        self.country = dictionary[@"country"];
        
        self.photoURL = [NSURL URLWithString:dictionary[@"photo"][@"photo_link"]];
        
        
    }
    return self;
}

+(void)retrieveMembeById:(NSString*)memberId withCompletion:(void (^)(Member *))complete{
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.meetup.com/2/member/%@?&sign=true&photo-host=public&page=20&key=477d1928246a4e162252547b766d3c6d", memberId]];

        NSURLRequest *request = [NSURLRequest requestWithURL:url];

        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                   NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

                                   Member *member = [[Member alloc]initWithDictionary:dict];
                                   complete(member);
                              }];
}

-(void)downloadUserImage:(void (^)(UIImage *))complete{
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:self.photoURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
       UIImage *image = [UIImage imageWithData:data];
        complete(image);
    }];
}




@end
