//
//  SideBarTableViewController.m
//  EnglishMemTrainer
//
//  Created by MacBookPro - Yuriy  on 7/14/16.
//  Copyright © 2016 com.mac.yuriy. All rights reserved.
//

#import "SideBarTableViewController.h"
#import "MenuTableViewCell.h"
#import "MainInteractiveViewController.h"
#import "SettingsTableViewController.h"

@interface SideBarTableViewController () {
    NSArray *menuItems;
}

@end

@implementation SideBarTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    menuItems = [[NSArray alloc] initWithObjects:@"Play", @"Settings", @"About", nil];
    self.tableView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [menuItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identier = [menuItems objectAtIndex:indexPath.row];
    MenuTableViewCell *cell = (MenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identier  forIndexPath:indexPath];
    cell.menuTitleLable.text = identier;

    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UINavigationController *destController = (UINavigationController *)segue.destinationViewController;
    destController.title = [menuItems objectAtIndex:indexPath.row];
    
    if ([segue.identifier isEqualToString:@"Play"]) {
        MainInteractiveViewController *mainViewController = (MainInteractiveViewController *)[destController topViewController];
        
    } else if ([segue.identifier isEqualToString:@"Settings"] ) {
        SettingsTableViewController *settingsController = (SettingsTableViewController *)[destController topViewController];
    }

}


@end
