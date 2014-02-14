//
//  QSCMyQuests.m
//  try3
//
//  Created by igor on 2/14/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import "QSCMyQuests.h"

@interface QSCMyQuests ()
@property NSMutableArray *quests;
@end

@implementation QSCMyQuests

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadInitialData {
    QSCQuest *quest = [[QSCQuest alloc] init];
    quest.name = @"Tel Aviv Magic";
    //    quest.durationD = [NSNumber numberWithFloat:8.2];
    //    quest.durationT = [NSNumber numberWithFloat:2.5];
    quest.rating = 3;
    [self.quests addObject:quest];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.quests = [[NSMutableArray alloc] init];
    [self loadInitialData];
    
    //    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    //    UINavigationController *navigationController = [tabBarController viewControllers][0];
    //    QSCAllQuestsViewController *questsViewController = [navigationController viewControllers][0];
    //    questsViewController.quests = self.quests;
//     self.navigationItem.rightBarButtonItem = self.editButtonItem;
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.quests count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuestCell"];
    static NSString *CellIdentifier = @"QuestCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    QSCQuest *quest = [self.quests objectAtIndex:indexPath.row];
    cell.textLabel.text = quest.name;
    //cell.detailTextLabel.text = [@"D:" stringByAppendingString:[NSString stringWithFormat:@"%@", quest.durationD]];
    return cell;
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
