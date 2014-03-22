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
@synthesize quest = _quest;
@synthesize content = _content;
@synthesize is_first = _is_first;


- (void) createWebViewWithHTML{
    //create the string
    NSMutableString *html = [NSMutableString stringWithString: @"<html><head><title></title></head><body style=\"background:transparent;\">"];
    
    //continue building the string
    if (self.content == Nil)
        [html appendString:@"first, please log in?"];
    else
        [html appendString:self.content[self.currPage]];

    [html appendString:@"</body></html>"];
    
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


- (void)viewDidLoad
{
    self.navigationItem.title = _quest.name;
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

- (IBAction)back:(id)sender
{
    [self.delegate QSCpageDidSave:self];
}


@end
