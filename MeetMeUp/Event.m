//
//  Event.m
//  MeetMeUp
//
//  Created by Dave Krawczyk on 9/8/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "Event.h"

@implementation Event


- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        self.name = dictionary[@"name"];
        

        self.eventID = dictionary[@"id"];
        self.RSVPCount = [NSString stringWithFormat:@"%@",dictionary[@"yes_rsvp_count"]];
        self.hostedBy = dictionary[@"group"][@"name"];
        self.eventDescription = dictionary[@"description"];
        self.address = dictionary[@"venue"][@"address"];
        self.eventURL = [NSURL URLWithString:dictionary[@"event_url"]];
        self.photoURL = [NSURL URLWithString:dictionary[@"photo_url"]];
    }
    return self;
}

+ (NSArray *)eventsFromArray:(NSArray *)incomingArray
{
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity:incomingArray.count];
    
    for (NSDictionary *d in incomingArray) {
        Event *e = [[Event alloc]initWithDictionary:d];
        [newArray addObject:e];
        
    }
    return newArray;
}

-(void)loadCommentsForEvent:(void (^)(NSArray *))complete{
    NSString* tmpString =[NSString stringWithFormat:@"https://api.meetup.com/2/event_comments?sign=true&photo-host=public&event_id=%@&page=20&key=477d1928246a4e162252547b766d3c6d ",self.eventID];

    NSURL *url = [NSURL URLWithString:[tmpString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

                               NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

                               NSArray *jsonArray = [dict objectForKey:@"results"];

                               complete([Comment objectsFromArray:jsonArray]);
                           }];
}

-(void)downloadEventImageFromURL:(void (^)(UIImage *))complete{
    NSURLRequest *imageReq = [NSURLRequest requestWithURL:self.photoURL];

    [NSURLConnection sendAsynchronousRequest:imageReq queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!connectionError) {
                complete([UIImage imageWithData:data]);
            }
        });


    }];

}

+(void)preformSearchWithKeyword:(NSString *)keyword withCompletionBlock:(void(^)(NSArray *))complete{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.meetup.com/2/open_events.json?zip=60604&text=%@&time=,1w&key=477d1928246a4e162252547b766d3c6d",keyword]];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

                               NSArray *jsonArray = [[NSJSONSerialization JSONObjectWithData:data
                                                                                     options:NSJSONReadingAllowFragments
                                                                                       error:nil] objectForKey:@"results"];
                               NSMutableArray *events = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];

                               for(NSDictionary *tempDic in jsonArray){
                                   Event *event = [[Event alloc] initWithDictionary:tempDic];
                                   [events addObject:event];
                               }
                               complete(events);
                               
                           }];
    
}

@end
