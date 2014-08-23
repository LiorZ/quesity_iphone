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
#import "QSCQuest.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"

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
    
//    for (NSString* family in [UIFont familyNames])
//    {
//        NSLog(@"%@", family);
//        
//        for (NSString* name in [UIFont fontNamesForFamilyName: family])
//        {
//            NSLog(@"  %@", name);
//        }
//    }
}

- (void) parseJson2Quests:(NSArray *)json {
    NSArray* titlesFromJson = [json valueForKey:@"title"];
    NSArray* timesFromJson = [json valueForKey:@"time"];
//    NSArray* distsFromJson = [json valueForKey:@"distance"];
//    NSArray* ratingsFromJson = [json valueForKey:@"rating"];
    NSArray* descriptionFromJson = [json valueForKey:@"description"];
    NSArray* idFromJson = [json valueForKey:@"_id"];
    NSArray* locationsFromJson = [json valueForKey:@"starting_location"];
    NSArray* imagesLinksFromJson = [json valueForKey:@"images"];
    NSArray* allowedHintsFromJson = [json valueForKey:@"allowed_hints"];
//    NSArray* gamesPlayedFromJson = [json valueForKey:@"games_played"];
//    NSArray* tagsFromJson = [json valueForKey:@"tags"];
    
    //update quests:
    self.quests = [[NSMutableArray alloc] init];
    
    myGlobalData *myGD = [[myGlobalData alloc] init];
    
    if (titlesFromJson.count>0) {
        //draw progrees:
        UIApplication* app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = YES;
        
//        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        self.hud.labelText = @"Loading...";
        
        dispatch_queue_t imageLoadingQueue = dispatch_queue_create("imageLoadingQueue", NULL);
        
        dispatch_async(imageLoadingQueue, ^{
            myUtilities *myUtils = [[myUtilities alloc] init];
            NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            
            int jDbg = 1;
            if (myGD.isDbg)
                jDbg = CELLS_2_DUPLICATE_4_DEBUG;
            
            for (int jjj=0; jjj<jDbg; jjj++) {
            for (int i=0; i<titlesFromJson.count; i++) {
                //parsing hebrew buisness
                NSString* questTitle = [myUtils parseString2Hebrew:titlesFromJson[i]];
                NSString* questDescription = [myUtils parseString2Hebrew:descriptionFromJson[i]];
                
                //NSLog(@"Output = %@", questTitle);
                
                QSCQuest *quest = [[QSCQuest alloc] init];
                quest.name = questTitle.copy;
                quest.description = questDescription.copy;
                
                NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
                if ([language isEqualToString:@"he"]) {
                    quest.durationT = [NSString stringWithFormat:@"%d דקות", [timesFromJson[i] intValue]];
                } else {
                    quest.durationT = [NSString stringWithFormat:@"%d minutes", [timesFromJson[i] intValue]];
                }
                
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
            }
        });
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Pull down to refresh the list"
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil];
        alert.tag = 42;
        [alert show];
//        self.emptyHud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
//        [self.emptyHud setMode:MBProgressHUDModeText];
//        self.emptyHud.labelText = @"Pull down to refresh";
    }
}


- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    if (responseData!=nil) {

        [self.timer invalidate];

        NSArray* json = [NSJSONSerialization
                         JSONObjectWithData:responseData
                         options:kNilOptions
                         error:&error];
        
        
        [self parseJson2Quests:json];
        
        [[NSUserDefaults standardUserDefaults] setObject:json forKey:@"myData"];
    }
}

- (void)updateTable
{
    //self.quests = [[NSMutableArray alloc] init];
    [self.tableView reloadData];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];

    [self.refreshControl endRefreshing];

//    if (self.isEmptyList)
//        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.emptyHud];
}

- (void)getJson
{
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Loading..."];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:TIMEOUT_FOR_CONNECTION target:self selector:@selector(stopSpinning) userInfo:nil repeats:NO];
    
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString:SITEURL_ALL_QUESTS]];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
    
    [self performSelector:@selector(updateTable)
          withObject:nil
          afterDelay:TIMEOUT_FOR_CONNECTION];
}

- (void) stopSpinning {
    [self.timer invalidate];
    [self.refreshControl endRefreshing];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error connecting to network", nil)
                                                    message:NSLocalizedString(@"Please try again with an active internet connection.",nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                          otherButtonTitles:nil];
    alert.tag = 442;
    //    NSLog(@"tag: %d",alert.tag);
    [alert show];
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [self loadInitialData];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //pull to refresh control:
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    refresh.tintColor = [UIColor whiteColor];
    [refresh addTarget:self
                action:@selector(getJson)
             forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    //if just got into the app:
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = @"Loading Quests...";
    [self getJson];
    //else
    //    [self loadInitialData];
    
    self.view.backgroundColor = QUESITY_COLOR_BG;//[UIColor clearColor];

    //a lot of code, just to put an image on the navigation bar
    float delta2center = 70;
    UIView *myView = [[UIView alloc] initWithFrame: CGRectMake(delta2center+0, 0, 300, 30)];
    UILabel *title = [[UILabel alloc] initWithFrame: CGRectMake(delta2center+40, 0, 300, 30)];

    title.text = NSLocalizedString(@"Select Quest", nil);
    [title setTextColor:QUESITY_COLOR_FONT];
    [title setFont:[UIFont boldSystemFontOfSize:20.0]];
    
    [title setBackgroundColor:[UIColor clearColor]];
    UIImage *image = [UIImage imageNamed:@"search.png"];
    UIImageView *myImageView = [[UIImageView alloc] initWithImage:image];
    
    myImageView.frame = CGRectMake(delta2center+0, 0, 30, 30);
//    myImageView.layer.cornerRadius = 5.0;
//    myImageView.layer.masksToBounds = YES;
//    myImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    myImageView.layer.borderWidth = 0.1;
    
    [myView addSubview:title];
    [myView setBackgroundColor:[UIColor  clearColor]];
    [myView addSubview:myImageView];
    self.navigationItem.titleView = myView;
    
//    [self getJson];
    
    
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
    myGlobalData *myGD = [[myGlobalData alloc] init];
    int jDbg = 1 + CELLS_2_DUPLICATE_4_DEBUG*(myGD.isDbg);
    return ([self.quests count])*jDbg;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuestCell"];
    static NSString *CellIdentifier = @"QuestCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    //for debug
    QSCQuest *quest = [self.quests objectAtIndex:(indexPath.row % self.quests.count)];

    UILabel *nameLabel = (UILabel *)[cell viewWithTag:100];
    nameLabel.text = quest.name;
    
    UILabel *museumLabel = (UILabel *)[cell viewWithTag:1001];
    museumLabel.text = quest.startLoc.street;
    
//    UILabel *distLabel = (UILabel *)[cell viewWithTag:110];
//    distLabel.text = [NSString stringWithFormat:@"%@",quest.durationD];

    UILabel *durLabel = (UILabel *)[cell viewWithTag:120];
    durLabel.text = [NSString stringWithFormat:@"%@",quest.durationT];
    
//    UILabel *gamesPlayedLabel = (UILabel *)[cell viewWithTag:130];
//    gamesPlayedLabel.text = [NSString stringWithFormat:@"%@",quest.gamesPlayed];
    
//    //rating stuff:
//    TPFloatRatingView *rv = [[TPFloatRatingView alloc] initWithFrame:CGRectMake(80.0, 30.0, 80.0, 40.0)];
//    rv.emptySelectedImage = [UIImage imageNamed:@"star-empty"];
//    rv.fullSelectedImage = [UIImage imageNamed:@"star-full"];
//    rv.contentMode = UIViewContentModeScaleAspectFill;
//    rv.maxRating = 5;
//    rv.minRating = 1;
//    rv.rating = quest.rating;
//    rv.editable = NO;
//    rv.halfRatings = NO;
//    rv.floatRatings = YES;
//    
    if (indexPath.row % 2 ==0) {
        cell.backgroundColor = QUESITY_COLOR_TABLE_EVEN;
    } else {
        cell.backgroundColor = QUESITY_COLOR_TABLE_ODD;
    }
    
//    [cell addSubview:rv];

//    UILabel *ratingLabel = (UILabel *)[cell viewWithTag:140];
//    ratingLabel.text = [NSString stringWithFormat:@"(%.1f)",quest.rating];

//    [cell addSubview:ratingLabel];
    
    // Here we use the new provided setImageWithURL: method to load the web image
    //[cell.imageView sd_setImageWithURL:[NSURL URLWithString:quest.imagesLinks[0]]
//                   placeholderImage:[UIImage imageNamed:@"logo_temp.png"]];
    
  UIImageView *questImg = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 15.0, 60.0, 60.0)];
    [questImg sd_setImageWithURL:[NSURL URLWithString:quest.imagesLinks[0]]
                placeholderImage:[UIImage imageNamed:@"logo_temp.png"]];
    
    questImg.image = quest.img;
    questImg.layer.cornerRadius = 30.0f;
    questImg.clipsToBounds = YES;
    //cell.imageView.frame = CGRectMake(10.0, 20.0, 60.0, 60.0);
//    cell.imageView.layer.cornerRadius = 30.0f;
//    cell.imageView.clipsToBounds = YES;

    [cell addSubview:questImg];
    
//    myUtilities *myUtils = [[myUtilities alloc] init];
//    [cell addSubview:[myUtils drawLine:CGRectMake(150.f, 50.f, 1.f, 40.f)]];
//    [cell addSubview:[myUtils drawLine:CGRectMake(210.f, 50.f, 1.f, 40.f)]];

//    [myUtils drawLine1:CGRectMake(150.f, 50.f, 1.f, 40.f) toView:cell];
//    [myUtils drawLine1:CGRectMake(210.f, 50.f, 1.f, 40.f) toView:cell];
    
    return cell;
    
}


#pragma mark - Navigation
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
