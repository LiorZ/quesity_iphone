//
//  QSCAllQuestsViewController.m
//  try3
//
//  Created by igor on 2/14/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import "QSCMyQuestsViewController2.h"
#import "QSCAllQuestsViewController2.h"

@interface QSCMyQuestsViewController2 ()

@property NSMutableArray *quests;

@end

@implementation QSCMyQuestsViewController2

- (void)loadInitialData {

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.quests = [[NSMutableArray alloc] init];
    [self loadInitialData];

    self.view.backgroundColor = [UIColor clearColor];
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
    /*
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuestCell"];
    static NSString *CellIdentifier = @"QuestCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    QSCQuest *quest = [self.quests objectAtIndex:indexPath.row];
    cell.textLabel.text = quest.name;
    cell.backgroundColor = [UIColor clearColor];

    //cell.detailTextLabel.text = [@"D:" stringByAppendingString:[NSString stringWithFormat:@"%@", quest.durationD]];
    return cell;
    */
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuestCell"];
    static NSString *CellIdentifier = @"QuestCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    QSCQuest *quest = [self.quests objectAtIndex:indexPath.row];
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:100];
    nameLabel.text = quest.name;
    
    UILabel *gameLabel = (UILabel *)[cell viewWithTag:101];
    //quest.durationD = distsFromJson[i];
    //quest.durationT = timesFromJson[i];
    gameLabel.text = [NSString stringWithFormat:@"Distance: %@ km, Time: %@",quest.durationD,quest.durationT];
    
    //rating stuff:
    TPFloatRatingView *rv = [[TPFloatRatingView alloc] initWithFrame:CGRectMake(210.0, 20.0, 80.0, 40.0)];
    rv.emptySelectedImage = [UIImage imageNamed:@"star-empty"];
    rv.fullSelectedImage = [UIImage imageNamed:@"star-full"];
    rv.contentMode = UIViewContentModeScaleAspectFill;
    rv.maxRating = 5;
    rv.minRating = 1;
    rv.rating = quest.rating;
    rv.editable = NO;
    rv.halfRatings = NO;
    rv.floatRatings = YES;
    
    [cell addSubview:rv];
    
    //UIImageView *ratingImageView = (UIImageView *)[cell viewWithTag:102];
    //ratingImageView.image = [self imageForRating:quest.rating];
    
    //cell.detailTextLabel.text = [@"D:" stringByAppendingString:[NSString stringWithFormat:@"%@", quest.durationD]];
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
   
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    NSLog(@"Going to details...");
//    if ([segue.identifier isEqualToString:@"showQuest2"]) {
//        ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"mainStoryboard"];
//        [self.navigationController pushViewController:vc animated:YES];
//
//        //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        //ViewController *destViewController = segue.destinationViewController;
//        //destViewController.quest = [self.quests objectAtIndex:indexPath.row];
//        //ViewController *itemDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
//        //[self.navigationController pushViewController:itemDetail animated:YES];
//    }
//}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"Going to details...");
//    
//    //ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"mainStoryboard"];
//    ViewController *vc = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
//
//    [self.navigationController pushViewController:vc animated:YES];
//
//    
//}

@end
