//
//  QSCpage.m
//  try3
//
//  Created by igor on 3/22/14.
//  Copyright (c) 2014 igor. All rights reserved.
//
#define SITEURL @"http://quesity.herokuapp.com/quest/"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

#import "QSCpage.h"
#import "myUtilities.h"

@implementation QSCpage
@synthesize webStuff2;
@synthesize quest = _quest;
@synthesize content = _content;
@synthesize is_first = _is_first;


- (void) createWebViewWithHTML{
    //create the string
    NSMutableString *html = [NSMutableString stringWithString: @"<html>"];
//    NSMutableString *html = [NSMutableString stringWithString: @"<html><body style=\"background:transparent;\">"];
    
    //continue building the string
    if (self.content == Nil)
        [html appendString:@"first, please log in?"];
    else
        [html appendString:self.content[self.currPage]];

    [html appendString:@"</html>"];
    
    //NSLog(@"%@",html);
    
    //instantiate the web view
    //UIWebView *webView2 = [[UIWebView alloc] initWithFrame:self.view.frame];
    
    //make the background transparent
    [webStuff2 setBackgroundColor:[UIColor clearColor]];
    
    //pass the string to the webview
    [webStuff2 loadHTMLString:[html description] baseURL:nil];
    
    //add it to the subview
    //[self.view addSubview:webView2];
    
}

- (NSUInteger) findFirst {
    return [self.is_first indexOfObjectIdenticalTo:@(YES)];
}

- (NSUInteger) findID: (NSString *)pageId {
    return [self.pagesId indexOfObject:pageId];
}


- (void)viewDidLoad
{
    //NSString *fullURL = @"http://quesity.herokuapp.com/home";
    //NSURL *url = [NSURL URLWithString:fullURL];
//    NSURL *questURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/pages", SITEURL, _quest.questId]];
//    
//    NSURLRequest *requestObj = [NSURLRequest requestWithURL:questURL];
//    [webStuff2 loadRequest:requestObj];

    self.navigationItem.title = _quest.name;
    
    self.currPage = [self findFirst];
    self.currType = @"regular";
    
    [self createWebViewWithHTML];
    
    [super viewDidLoad];
}


- (NSString *) parseJsonOfLinks:(NSArray *)links {
    return [links valueForKey:@"links_to_page"];
}

- (NSString *) getTypeFromLink:(NSArray *)link {
    return [link valueForKey:@"type"];
}

- (NSString *) getAnswerFromLink:(NSArray *)link {
    return [link valueForKey:@"answer_txt"];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *ans1 = [[alertView textFieldAtIndex:0] text];
    NSLog(@"Entered: %@",ans1);
    if ([self.currCorrectAnswer isEqualToString:ans1]) {
        NSLog(@"Correct");

        NSArray *links = self.linksToOthers[self.currPage];
        NSLog(@"yo! %@",links[0]);
        NSUInteger nextPage = [self findID:[self parseJsonOfLinks:links[0]]];
        NSLog(@"%@, which is on index: %d",[self parseJsonOfLinks:links[0]], nextPage);
        self.currPage = nextPage;
        
        [self createWebViewWithHTML];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Nope, sorry"
                                                        message:@"That's not the correct answer."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)didPressButton2:(id)sender {
    NSArray *links = self.linksToOthers[self.currPage];
    NSLog(@"there are %d links from here",links.count);
    for (int i=0; i<links.count; i++) {
        self.currType = [self getTypeFromLink:links[i]];
        NSLog(@"type (curr. page): %@",self.currType);
        if ([self.currType isEqualToString:@"answer"]) {
            self.currCorrectAnswer = [self getAnswerFromLink:links[i]];
            NSLog(@"(Correct Answer is:%@)",self.currCorrectAnswer);
            //myUtilities *obj = [[myUtilities  alloc]init];
            //self.currCorrectAnswer = [obj parseString2Hebrew:self.currCorrectAnswer];
        }
    }
    
    if ([self.currType isEqualToString:@"answer"]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Hello!" message:@"Please enter the answer:" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField * alertTextField = [alert textFieldAtIndex:0];
        alertTextField.placeholder = @"answer";
        [alert show];
    } else {
        NSArray *links = self.linksToOthers[self.currPage];
        NSLog(@"yo! %@",links[0]);
        NSUInteger nextPage = [self findID:[self parseJsonOfLinks:links[0]]];
        NSLog(@"%@, which is on index: %d",[self parseJsonOfLinks:links[0]], nextPage);
        self.currPage = nextPage;
        
        [self createWebViewWithHTML];
    }
}


- (IBAction)back:(id)sender
{
    [self.delegate QSCpageDidSave:self];
}


@end
