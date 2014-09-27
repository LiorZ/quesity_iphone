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
#import <CoreLocation/CoreLocation.h>


@interface QSCAllQuestsViewController2 ()
@property NSMutableArray *quests;
@property BOOL isFiltered;
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
    NSArray* descriptionFromJson = [json valueForKey:@"description"];
    NSArray* idFromJson = [json valueForKey:@"_id"];
    NSArray* locationsFromJson = [json valueForKey:@"starting_location"];
    NSArray* imagesLinksFromJson = [json valueForKey:@"images"];
    NSArray* allowedHintsFromJson = [json valueForKey:@"allowed_hints"];
    
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
                    UIImage *img;
                    if (quest.imagesLinks.count>0) {
                        NSString *imgName = [myUtils getFileFromPath:quest.imagesLinks[0]];
                        NSString *pathForImg = [myUtils getPathForSavedImage:imgName withQuestId:quest.questId];
                        
                        if (pathForImg!=nil) {
                            img = [myUtils loadImage:pathForImg inDirectory:documentsDirectoryPath];
                        } else {
                            img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:quest.imagesLinks[0]]]];
                            
                            [myUtils saveImage:img
                                  withFileName:[NSString stringWithFormat:@"%@_%@", quest.questId, imgName]
                                   inDirectory:documentsDirectoryPath];
                            
                            [myUtils addPathForSavedImage:imgName withQuestId:quest.questId];
                        }
                    } else {
                        img = [UIImage imageNamed:@"logo_temp.png"];
                    }
                
                    dispatch_async(dispatch_get_main_queue(), ^{
                        quest.img = img;
                        [self.quests addObject:quest];
                        
                        if (titlesFromJson.count==self.quests.count) {
                            app.networkActivityIndicatorVisible = NO;
                            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];

                            //[self sortByDistance];
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


//- (void) sortByDistance {
//    
//    NSArray *rawData = [NSArray arrayWithContentsOfFile:pathDoc];
//    
//    rawData = [rawData sortedArrayUsingComparator: ^(id a, id b) {
//        
//        CLLocationDistance dist_a= [[a objectsForKey:@"coordinate"] distanceFromLocation: userPosition];
//        CLLocationDistance dist_b= [[b objectsForKey:@"coordinate"] distanceFromLocation: userPosition];
//        if ( dist_a < dist_b ) {
//            return (NSComparisonResult)NSOrderedAscending;
//        } else if ( dist_a > dist_b) {
//            return (NSComparisonResult)NSOrderedDescending;
//        } else {
//            return (NSComparisonResult)NSOrderedSame;
//        }
//    }
//    
//}


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
    
//    [self performSelector:@selector(updateTable)
//               withObject:nil
//               afterDelay:TIMEOUT_FOR_CONNECTION];
}

- (void) stopSpinning {
    [self.timer invalidate];
    [self.refreshControl endRefreshing];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error connecting to network", nil)
                                                    message:NSLocalizedString(@"Please try again with an active internet connection.",nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                          otherButtonTitles:nil];
    alert.tag = 442;
    //    NSLog(@"tag: %d",alert.tag);
    [alert show];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.mySearchBar.hidden = NO;
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGRect rect = _searchBar.frame;
//    rect.origin.y = MIN(0, scrollView.contentOffset.y);
//    _searchBar.frame = rect;
//}

-(void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.mySearchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.mySearchBar.text = nil;
    
    _isFiltered = NO;
    [self updateTable];
    
    //hide cancel button
    [self.mySearchBar setShowsCancelButton:NO animated:YES];
    
    [self.mySearchBar resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mySearchBar = [[UISearchBar alloc]
                        initWithFrame:CGRectMake(0.0, 20.0, self.view.bounds.size.width,44.0)];
	self.mySearchBar.delegate = self;
	self.mySearchBar.barTintColor = QUESITY_COLOR_BG;
    self.mySearchBar.placeholder = NSLocalizedString(@"Select Quest", nil);

	[self.navigationController.view addSubview: self.mySearchBar];
    
    self.mySearchBar.hidden = NO;
    
    //pull to refresh control:
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    refresh.tintColor = [UIColor whiteColor];
    [refresh addTarget:self
                action:@selector(getJson)
      forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    //if just got into the app:
    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    self.hud.labelText = @"Loading Quests...";
    [self.navigationController.view bringSubviewToFront:self.hud];
    
    self.view.backgroundColor = QUESITY_COLOR_BG;//[UIColor clearColor];
    
    [self getJson];
    
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
    
    int rowCount;
    if(self.isFiltered) {
        rowCount = (int)_filteredTableData.count;
    } else {
        rowCount = (int)([self.quests count])*jDbg;
    }
    
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuestCell"];
    static NSString *CellIdentifier = @"QuestCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    QSCQuest *quest;
    if (_isFiltered) {
        quest = [_filteredTableData objectAtIndex:(indexPath.row % self.quests.count)];
    } else {
        quest = [self.quests objectAtIndex:(indexPath.row % self.quests.count)];
    }
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:100];
    nameLabel.text = quest.name;
    
    UILabel *museumLabel = (UILabel *)[cell viewWithTag:1001];
    museumLabel.text = quest.startLoc.street;
    
    UILabel *durLabel = (UILabel *)[cell viewWithTag:120];
    durLabel.text = [NSString stringWithFormat:@"%@",quest.durationT];
    
    if (indexPath.row % 2 ==0) {
        cell.backgroundColor = QUESITY_COLOR_TABLE_EVEN_NOALPHA;
    } else {
        cell.backgroundColor = QUESITY_COLOR_TABLE_ODD_NOALPHA;
    }
    
    
    UIImageView *questImg = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 15.0, 60.0, 60.0)];
    [questImg sd_setImageWithURL:[NSURL URLWithString:quest.imagesLinks[0]]
                placeholderImage:[UIImage imageNamed:@"logo_temp.png"]];
    
    questImg.image = quest.img;
    questImg.layer.cornerRadius = 30.0f;
    questImg.clipsToBounds = YES;
    
    [cell addSubview:questImg];
    
    return cell;
    
}

//thanks to http://code-ninja.org/blog/2012/01/08/ios-quick-tip-filtering-a-uitableview-with-a-search-bar/
-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if(text.length == 0)
    {
//        [self.mySearchBar setShowsCancelButton:NO animated:YES];

        _isFiltered = FALSE;
//        [self.mySearchBar performSelector:@selector(resignFirstResponder)
//                               withObject:nil
//                               afterDelay:0];
    }
    else
    {
        _isFiltered = true;
        _filteredTableData = [[NSMutableArray alloc] init];
        
        for (QSCQuest* q in self.quests)
        {
            NSRange nameRange = [q.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange descriptionRange = [q.startLoc.street rangeOfString:text options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound || descriptionRange.location != NSNotFound)
            {
                [_filteredTableData addObject:q];
            }
        }
    }
    
    [self.tableView reloadData];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showQuestAll"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        QSCQuestInfoViewController *destViewController = segue.destinationViewController;
        
        if (_isFiltered) {
            destViewController.quest = [_filteredTableData objectAtIndex:indexPath.row];
        } else {
            destViewController.quest = [self.quests objectAtIndex:indexPath.row];
        }
        destViewController.quest = [self.quests objectAtIndex:indexPath.row];

        self.mySearchBar.hidden = YES;
        [self.mySearchBar performSelector:@selector(resignFirstResponder)
                               withObject:nil
                               afterDelay:0];

        UIApplication* app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = YES;
    }
}

@end
