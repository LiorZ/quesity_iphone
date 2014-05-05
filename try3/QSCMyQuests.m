//
//  QSCMyQuests.m
//  try3
//
//  Created by igor on 2/14/14.
//  Copyright (c) 2014 igor. All rights reserved.
//
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1
#define allQuestsURL [NSURL URLWithString:@"http://quesity.herokuapp.com/all_quests"] //2

#import "QSCMyQuests.h"
#import "QSCQuestInfoViewController.h"
#import "TPFloatRatingView.h"

@interface QSCMyQuests ()
@property NSMutableArray *quests;
@end

@implementation QSCMyQuests
//@synthesize tableView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadInitialData {

    //loading quests
    NSArray* json = [[NSUserDefaults standardUserDefaults] valueForKey: @"myData"];
    [self parseJson2Quests:json];
    

//    QSCQuest *quest = [[QSCQuest alloc] init];
//    quest.name = @"Tel Aviv Magic";
//    //    quest.durationD = [NSNumber numberWithFloat:8.2];
//    //    quest.durationT = [NSNumber numberWithFloat:2.5];
//    quest.rating = 3;
//    [self.quests addObject:quest];
//    
//    QSCQuest *quest1 = [[QSCQuest alloc] init];
//    quest1.name = @"Jerusalem with Galila";
//    //    quest.durationD = [NSNumber numberWithFloat:6.2];
//    //    quest.durationT = [NSNumber numberWithFloat:3.4];
//    quest1.rating = 4;
//    [self.quests addObject:quest1];
}

- (NSString *) parseString2Hebrew:(NSString *)str2parse
{
    // will cause trouble if you have "abc\\\\uvw"
    NSString* esc1 = [str2parse stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString* esc2 = [esc1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString* quoted = [[@"\"" stringByAppendingString:esc2] stringByAppendingString:@"\""];
    NSData* data = [quoted dataUsingEncoding:NSUTF8StringEncoding];
    NSString* unesc = [NSPropertyListSerialization propertyListFromData:data
                                                       mutabilityOption:NSPropertyListImmutable format:NULL
                                                       errorDescription:NULL];
    assert([unesc isKindOfClass:[NSString class]]);
    return unesc;
}

- (void) parseJson2Quests:(NSArray *)json {
    NSArray* titlesFromJson = [json valueForKey:@"title"];
    NSArray* timesFromJson = [json valueForKey:@"time"];
    NSArray* distsFromJson = [json valueForKey:@"distance"];
    NSArray* ratingsFromJson = [json valueForKey:@"rating"];
    NSArray* descriptionFromJson = [json valueForKey:@"description"];
    NSArray* idFromJson = [json valueForKey:@"_id"];
    NSArray* locationsFromJson = [json valueForKey:@"starting_location"];
    NSArray* imagesLinksFromJson = [json valueForKey:@"images"];
    NSArray* allowedHintsFromJson = [json valueForKey:@"allowed_hints"];
    
    //update quests:
    self.quests = [[NSMutableArray alloc] init];
    
    for (int i=0; i<titlesFromJson.count; i++) {
        //parsing hebrew buisness
        NSString* questTitle = [self parseString2Hebrew:titlesFromJson[i]];
        NSString* questDescription = [self parseString2Hebrew:descriptionFromJson[i]];

        //NSLog(@"Output = %@", questTitle);
        
        QSCQuest *quest = [[QSCQuest alloc] init];
        quest.name = questTitle.copy;
        quest.description = questDescription.copy;
        quest.durationD = distsFromJson[i];

        int minutes = round([timesFromJson[i] intValue] / 60);
        int seconds = round([timesFromJson[i] intValue] % 60);
        
        quest.durationT = [NSString stringWithFormat:@"%d:%02d", minutes, seconds];
        quest.rating = [ratingsFromJson[i] floatValue];
        
        quest.questId = idFromJson[i];
        
        quest.startLoc = [[QSCLocation alloc] init];
        quest.startLoc.lat = [locationsFromJson[i] objectForKey:@"lat"];
        quest.startLoc.lng = [locationsFromJson[i] objectForKey:@"lng"];
        quest.startLoc.rad = [locationsFromJson[i] objectForKey:@"radius"];
        quest.startLoc.street = [locationsFromJson[i] objectForKey:@"street"];
        
        quest.imagesLinks = [[NSArray alloc] init];
        quest.imagesLinks  = imagesLinksFromJson[i];

        quest.allowedHints = allowedHintsFromJson[i];
        
        [self.quests addObject:quest];
    }
}

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSArray* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
   

    [self parseJson2Quests:json];
    
    [[NSUserDefaults standardUserDefaults] setObject:json forKey:@"myData"];
}

- (void)updateTable
{
    //self.quests = [[NSMutableArray alloc] init];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void)getJson
{
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: allQuestsURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
    
    [self performSelector:@selector(updateTable)
          withObject:nil
          afterDelay:1];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //pull to refresh stuff:
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    refresh.tintColor = [UIColor whiteColor];
    [refresh addTarget:self
                action:@selector(getJson)
             forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    [self loadInitialData];
    
    self.view.backgroundColor = [UIColor clearColor];


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

- (UIImage *)imageForRating:(int)rating
{
    switch (rating) {
        case 1: return [UIImage imageNamed:@"1StarSmall"];
        case 2: return [UIImage imageNamed:@"2StarsSmall"];
        case 3: return [UIImage imageNamed:@"3StarsSmall"];
        case 4: return [UIImage imageNamed:@"4StarsSmall"];
        case 5: return [UIImage imageNamed:@"5StarsSmall"];
    }
    return nil;
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


#pragma mark - Navigation
/*
// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    UIView *loadingVew = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 80, 80)];
////    loadingVew.center = self.view.center;
////    loadingVew.backgroundColor = [UIColor blackColor];
////    [self.view addSubview:loadingVew];
//    NSLog(@"adding view");
//
//    UIView *loadingVew = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 80, 80)];
//    loadingVew.center = self.view.center;
//    loadingVew.backgroundColor = [UIColor blackColor];
//
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:1.0];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
//                           forView:loadingVew
//                             cache:YES];
//    
//    [self.navigationController.view addSubview:loadingVew];
//    [UIView commitAnimations];
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showQuest"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        QSCQuestInfoViewController *destViewController = segue.destinationViewController;
        destViewController.quest = [self.quests objectAtIndex:indexPath.row];

        UIApplication* app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = YES;
    }
}

@end
