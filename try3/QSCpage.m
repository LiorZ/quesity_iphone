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

@implementation QSCpage
@synthesize webStuff2;
@synthesize webStuff3=_webStuff3;
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
    
    NSLog(@"%@",html);
    
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

    self.currPage = [self findFirst];
    [self createWebViewWithHTML];
    
    [super viewDidLoad];
}


- (NSString *) parseJsonOfLinks:(NSArray *)links {
    return [links valueForKey:@"links_to_page"];
}

- (IBAction)didPressButton2:(id)sender {
    NSArray *links = self.linksToOthers[self.currPage];
    NSLog(@"yo2! %d",links.count);
    NSLog(@"yo3! %@",links[0]);
    for (int i=0; i<links.count; i++) {
        NSUInteger nextPage = [self findID:[self parseJsonOfLinks:links[i]]];
        NSLog(@"%@, which is on index: %d",[self parseJsonOfLinks:links[i]], nextPage);
        self.currPage = nextPage;
    }
    [self createWebViewWithHTML];
}


- (IBAction)back:(id)sender
{
    [self.delegate QSCpageDidSave:self];
}


@end
