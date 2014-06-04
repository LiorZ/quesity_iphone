//
//  QSCAllQuestsViewController.m
//  try3
//
//  Created by igor on 2/14/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import "QSCMyQuestsViewController2.h"
#import "QSCQuestInfoViewController.h"
#import "TPFloatRatingView.h"
#import "myUtilities.h"
#import "myGlobalData.h"
#import "MBProgressHUD.h"
#import "QSCQuest.h"

@interface QSCMyQuestsViewController2 ()

@property NSMutableArray *quests;
@property NSInteger howManyParsed;

@end

@implementation QSCMyQuestsViewController2


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
    NSArray* tagsFromJson = [json valueForKey:@"tags"];
    
    //update quests:
    self.quests = [[NSMutableArray alloc] init];

    if (titlesFromJson.count>0) {
        //draw progrees:
        UIApplication* app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = YES;
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Loading...";
        
        dispatch_queue_t imageLoadingQueue = dispatch_queue_create("imageLoadingQueue", NULL);

        self.howManyParsed = 0;
        
        dispatch_async(imageLoadingQueue, ^{
            myUtilities *myUtils = [[myUtilities alloc] init];
            NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            
            for (int i=0; i<titlesFromJson.count; i++) {

                QSCQuest *quest = [[QSCQuest alloc] init];
                
                quest.questId = idFromJson[i];
               
                //parsing hebrew buisness
                NSString* questTitle = [myUtils parseString2Hebrew:titlesFromJson[i]];
                NSString* questDescription = [myUtils parseString2Hebrew:descriptionFromJson[i]];
                
                //NSLog(@"Output = %@", questTitle);
                
                quest.name = questTitle.copy;
                quest.description = questDescription.copy;
                quest.durationD = distsFromJson[i];
                quest.gamesPlayed = gamesPlayedFromJson[i];
                
                int minutes = round([timesFromJson[i] intValue] / 60);
                int seconds = round([timesFromJson[i] intValue] % 60);
                
                quest.durationT = [NSString stringWithFormat:@"%d:%02d", minutes, seconds];
                quest.rating = [ratingsFromJson[i] floatValue];
                
                quest.startLoc = [[QSCLocation alloc] init];
                quest.startLoc.lat = [locationsFromJson[i] objectForKey:@"lat"];
                quest.startLoc.lng = [locationsFromJson[i] objectForKey:@"lng"];
                quest.startLoc.rad = [locationsFromJson[i] objectForKey:@"radius"];
                quest.startLoc.street = [locationsFromJson[i] objectForKey:@"street"];
                
                quest.imagesLinks = [[NSArray alloc] init];
                quest.imagesLinks  = imagesLinksFromJson[i];
                
                quest.allowedHints = allowedHintsFromJson[i];
                
                quest.tags = tagsFromJson[i];
                
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
                    
                    ////// check whether there is a saved state:
                    //path of quest state:
                    NSString *questStatePath = [NSString stringWithFormat:@"%@_questState",quest.questId];
                    
                    //loading quest state:
                    NSDictionary* stateDict = [[NSUserDefaults standardUserDefaults] objectForKey: questStatePath];
                    
                    //check whether exists
                    if (stateDict!=nil) {
                        [self.quests addObject:quest];
                    }
                    self.howManyParsed = self.howManyParsed+1;
                    
                    //NSLog(@"titles: %d, parsed: %d",titlesFromJson.count,self.howManyParsed);
                    
                    if (titlesFromJson.count==self.howManyParsed) {
                        app.networkActivityIndicatorVisible = NO;
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [self updateTable];
                    }
                });
            }
        });
    }
}


- (void)updateTable
{
    [self.tableView reloadData];
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
    static NSString *CellIdentifier = @"QuestCell1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    QSCQuest *quest = [self.quests objectAtIndex:indexPath.row];
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:100];
    nameLabel.text = quest.name;
    
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
    //    [cell addSubview:[myUtils drawLine:CGRectMake(150.f, 50.f, 1.f, 40.f)]];
    //    [cell addSubview:[myUtils drawLine:CGRectMake(210.f, 50.f, 1.f, 40.f)]];
    
    [myUtils drawLine1:CGRectMake(150.f, 50.f, 1.f, 40.f) toView:cell];
    [myUtils drawLine1:CGRectMake(210.f, 50.f, 1.f, 40.f) toView:cell];
    return cell;
    
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showQuestMy"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        QSCQuestInfoViewController *destViewController = segue.destinationViewController;
        destViewController.quest = [self.quests objectAtIndex:indexPath.row];
        
        UIApplication* app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = YES;
    }
}

@end
