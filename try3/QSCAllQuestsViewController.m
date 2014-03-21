//
//  QSCAllQuestsViewController.m
//  try3
//
//  Created by igor on 2/14/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import "QSCAllQuestsViewController.h"

@interface QSCAllQuestsViewController ()

@property NSMutableArray *quests;

@end

@implementation QSCAllQuestsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    
    QSCQuest *quest1 = [[QSCQuest alloc] init];
    quest1.name = @"Jerusalem with Galila";
    //    quest.durationD = [NSNumber numberWithFloat:6.2];
    //    quest.durationT = [NSNumber numberWithFloat:3.4];
    quest1.rating = 4;
    [self.quests addObject:quest1];
    
    QSCQuest *quest2 = [[QSCQuest alloc] init];
    quest2.name = @"Mini-Macro Israel";
    //    quest.durationD = [NSNumber numberWithFloat:3];
    //    quest.durationT = [NSNumber numberWithFloat:1.5];
    quest2.rating = 2;
    [self.quests addObject:quest2];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.quests = [[NSMutableArray alloc] init];
    [self loadInitialData];
    
    self.view.backgroundColor = [UIColor clearColor];

//    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
//    UINavigationController *navigationController = [tabBarController viewControllers][0];
//    QSCAllQuestsViewController *questsViewController = [navigationController viewControllers][0];
//    questsViewController.quests = self.quests;
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
    cell.backgroundColor = [UIColor clearColor];

    //cell.detailTextLabel.text = [@"D:" stringByAppendingString:[NSString stringWithFormat:@"%@", quest.durationD]];
    return cell;
   
}

@end
