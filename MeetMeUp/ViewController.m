//
//  ViewController.m
//  MeetMeUp
//
//  Created by Dave Krawczyk on 9/8/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "Event.h"
#import "EventDetailViewController.h"
#import "ViewController.h"

@interface ViewController () <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *searchBar;
@property (nonatomic, strong) NSArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];

    [Event preformSearchWithKeyword:@"mobile" withCompletionBlock:^(NSArray *events) {
        self.dataArray = events;
    }];

}




-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self.tableView reloadData];
}

#pragma mark - Tableview Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell"];
    
    Event *e = self.dataArray[indexPath.row];
    
    cell.textLabel.text = e.name;
    cell.detailTextLabel.text = e.address;
    if (e.photoURL)
    {
        [e downloadEventImageFromURL:^(UIImage *image) {
            cell.imageView.image = image;
        }];

    }else
    {
       [cell.imageView setImage:[UIImage imageNamed:@"logo"]];
    }
    
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    EventDetailViewController *detailVC = [segue destinationViewController];

    Event *e = self.dataArray[self.tableView.indexPathForSelectedRow.row];
    detailVC.event = e;
}

#pragma searchbar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [Event preformSearchWithKeyword:searchBar.text withCompletionBlock:^(NSArray *events) {
        self.dataArray = events;
    }];
    [searchBar resignFirstResponder];
}

@end
