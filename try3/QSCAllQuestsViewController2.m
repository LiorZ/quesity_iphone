//
//  QSCAllQuestsViewController2.m
//  try3
//
//  Created by igor on 2/14/14.
//  Copyright (c) 2014 igor. All rights reserved.
//
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

#import "QSCAllQuestsViewController2.h"
#import "QSCQuestInfoViewController.h"
#import "TPFloatRatingView.h"
#import "myUtilities.h"
#import "myGlobalData.h"
#import "MBProgressHUD.h"

@interface QSCAllQuestsViewController2 ()
@property NSMutableArray *quests;
@end

@implementation QSCAllQuestsViewController2
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
    NSArray* gamesPlayedFromJson = [json valueForKey:@"games_played"];
    
    //update quests:
    self.quests = [[NSMutableArray alloc] init];
    
    if (titlesFromJson.count>0) {
        //draw progrees:
        UIApplication* app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = YES;
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Loading...";
        
        dispatch_queue_t imageLoadingQueue = dispatch_queue_create("imageLoadingQueue", NULL);
        
        dispatch_async(imageLoadingQueue, ^{
            myUtilities *myUtils = [[myUtilities alloc] init];
            NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            
            for (int i=0; i<titlesFromJson.count; i++) {
                //parsing hebrew buisness
                NSString* questTitle = [myUtils parseString2Hebrew:titlesFromJson[i]];
                NSString* questDescription = [myUtils parseString2Hebrew:descriptionFromJson[i]];
                
                //NSLog(@"Output = %@", questTitle);
                
                QSCQuest *quest = [[QSCQuest alloc] init];
                quest.name = questTitle.copy;
                quest.description = questDescription.copy;
                quest.durationD = distsFromJson[i];
                quest.gamesPlayed = gamesPlayedFromJson[i];
                
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
                
                //LOADING IMAGE:
                NSString *imgName = [myUtils getFileFromPath:quest.imagesLinks[0]];
                NSString *pathForImg = [myUtils getPathForSavedImage:imgName withQuestId:quest.questId];
                
                UIImage *img;
                if (pathForImg!=nil) {
                    img = [myUtils loadImage:pathForImg inDirectory:documentsDirectoryPath];
                } else {
                    img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:quest.imagesLinks[0]]]];
                    
                    [myUtils saveImage:img
                          withFileName:[NSString stringWithFormat:@"%@_%@", quest.questId, imgName]
                           inDirectory:documentsDirectoryPath];
                    
                    [myUtils addPathForSavedImage:imgName withQuestId:quest.questId];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    quest.img = img;
                    [self.quests addObject:quest];
                    
                    if (titlesFromJson.count==self.quests.count) {
                        app.networkActivityIndicatorVisible = NO;
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [self updateTable];
                    }
                });
            }
        });
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
        NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString:SITEURL_ALL_QUESTS]];
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
    
//    UILabel *gameLabel = (UILabel *)[cell viewWithTag:101];
//    //quest.durationD = distsFromJson[i];
//    //quest.durationT = timesFromJson[i];
//    gameLabel.text = [NSString stringWithFormat:@"Distance: %@ km, Time: %@",quest.durationD,quest.durationT];
    
    UILabel *distLabel = (UILabel *)[cell viewWithTag:110];
    distLabel.text = [NSString stringWithFormat:@"%@",quest.durationD];

    UILabel *durLabel = (UILabel *)[cell viewWithTag:120];
    durLabel.text = [NSString stringWithFormat:@"%@",quest.durationT];
    
    UILabel *gamesPlayedLabel = (UILabel *)[cell viewWithTag:130];
    gamesPlayedLabel.text = [NSString stringWithFormat:@"%@",quest.gamesPlayed];
    
    //rating stuff:
    TPFloatRatingView *rv = [[TPFloatRatingView alloc] initWithFrame:CGRectMake(80.0, 30.0, 80.0, 40.0)];
    rv.emptySelectedImage = [UIImage imageNamed:@"star-empty"];
    rv.fullSelectedImage = [UIImage imageNamed:@"star-full"];
    rv.contentMode = UIViewContentModeScaleAspectFill;
    rv.maxRating = 5;
    rv.minRating = 1;
    rv.rating = quest.rating;
    rv.editable = NO;
    rv.halfRatings = NO;
    rv.floatRatings = YES;
    
    if (indexPath.row % 2 ==0) {
        cell.backgroundColor = QUESITY_COLOR_TABLE_EVEN;
    } else {
        cell.backgroundColor = QUESITY_COLOR_TABLE_ODD;
    }
    
    [cell addSubview:rv];

    UILabel *ratingLabel = (UILabel *)[cell viewWithTag:140];
    ratingLabel.text = [NSString stringWithFormat:@"(%.1f)",quest.rating];

    [cell addSubview:ratingLabel];
    
    UIImageView *questImg = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 20.0, 60.0, 60.0)];
    questImg.image = quest.img;   
    questImg.layer.cornerRadius = 30.0f;
    questImg.clipsToBounds = YES;

    [cell addSubview:questImg];
    
    myUtilities *myUtils = [[myUtilities alloc] init];
    [cell addSubview:[myUtils drawLine:CGRectMake(150.f, 50.f, 1.f, 40.f)]];
    [cell addSubview:[myUtils drawLine:CGRectMake(210.f, 50.f, 1.f, 40.f)]];
    
    

    //UIImageView *ratingImageView = (UIImageView *)[cell viewWithTag:102];
    //ratingImageView.image = [self imageForRating:quest.rating];

    //cell.detailTextLabel.text = [@"D:" stringByAppendingString:[NSString stringWithFormat:@"%@", quest.durationD]];
    
    //cell.backgroundColor = [UIColor clearColor];

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
    if ([segue.identifier isEqualToString:@"showQuestAll"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        QSCQuestInfoViewController *destViewController = segue.destinationViewController;
        destViewController.quest = [self.quests objectAtIndex:indexPath.row];

        UIApplication* app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = YES;
    }
}

@end