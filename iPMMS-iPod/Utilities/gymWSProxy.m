//
//  gymWSProxy.m
//  iPMMS_iPad
//
//  Created by Imac DOM on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "gymWSProxy.h"

@implementation gymWSProxy

- (id) initWithReportType:(NSString*) resultType andInputParams:(NSDictionary*) prmDict andNotificatioName:(NSString*) notificationName;
{
    self = [super init];
    if (self) {
        _resultType = [[NSString alloc] initWithFormat:@"%@", resultType];
        _notificationName = [[NSString alloc] initWithFormat:@"%@", notificationName];
        if (prmDict) 
            inputParms = [[NSDictionary alloc] initWithDictionary:prmDict];
        dictData = [[NSMutableArray alloc] init];
        [self generateData];
    }
    return self;    
}

- (void) generateData
{
    NSString *soapMessage,*msgLength,*soapAction;
    NSURL *url;
    NSMutableURLRequest *theRequest;
    NSURLConnection *theConnection;
    
    if ([_resultType isEqualToString:@"UPDATECHECKOUT"]==YES) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<gymUpdateCheckOut_ipod xmlns=\"http://com.aahg.gymws_ipod/\">\n"
                       "<p_checkinid>%@</p_checkinid>\n"
                       "</gymUpdateCheckOut_ipod>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>",[inputParms valueForKey:@"p_checkinid"]];
        
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL,WS_ENV,MEMBERUPDATECHECKOUT_URL]];
        soapAction = [NSString stringWithFormat:@"%@",@"http://com.aahg.gymws_ipod/gymUpdateCheckOut_ipod"];
    }
    
    
    if ([_resultType isEqualToString:@"ADDCHECKIN"]==YES) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<gymCreateCheckIn_ipod xmlns=\"http://com.aahg.gymws_ipod/\">\n"
                       "<p_memberid>%@</p_memberid>\n"
                       "<p_checkintype>%@</p_checkintype>\n"
                       "</gymCreateCheckIn_ipod>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>",[inputParms valueForKey:@"p_memberid"], [inputParms valueForKey:@"p_checkintype"]];
        
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL,WS_ENV,MEMBERADDCHECKIN_URL]];
        soapAction = [NSString stringWithFormat:@"%@",@"http://com.aahg.gymws_ipod/gymCreateCheckIn_ipod"];
    }
    
    if ([_resultType isEqualToString:@"MEMBERNOTESFORSTATUSCHANGE"]==YES) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<GymMemberNotes_ipod xmlns=\"http://com.aahg.gymws_ipod/\">\n"
                       "<p_memberid>%@</p_memberid>\n"
                       "</GymMemberNotes_ipod>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>",[inputParms valueForKey:@"MEMBERID"]];
        
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL,WS_ENV,MEMBERNOTESFORSTATUS_URL]];
        //NSLog(@"the url link is %@",url);
        soapAction = [NSString stringWithFormat:@"%@",@"http://com.aahg.gymws_ipod/GymMemberNotes_ipod"];
    }

    if ([_resultType isEqualToString:@"MEMBERDATAIPOD"]==YES) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<getMemberData_iPod xmlns=\"http://com.aahg.gymws_ipod/\">\n"
                       "<p_memberid>%@</p_memberid>\n"
                       "</getMemberData_iPod>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>",[inputParms valueForKey:@"MEMBERID"]];
        
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL,WS_ENV,MEMBERDATAIPOD_URL]];
        //NSLog(@"the url link is %@",url);
        soapAction = [NSString stringWithFormat:@"%@",@"http://com.aahg.gymws_ipod/getMemberData_iPod"];
    }
    
    if ([_resultType isEqualToString:@"MEMBERSLIST"]==YES) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<MembersList xmlns=\"http://com.aahg.gymws_ipod/\">\n"
                       "<p_searchtext>%@</p_searchtext>\n"
                       "</MembersList>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>",[inputParms valueForKey:@"p_searchtext"]];
        
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL,WS_ENV,MEMBERSLIST_URL]];
        //NSLog(@"the url link is %@",url);
        soapAction = [NSString stringWithFormat:@"%@",@"http://com.aahg.gymws_ipod/MembersList"];
    }
    
    
    if ([_resultType isEqualToString:@"LOCATIONSLIST"]==YES) 
    {
        soapMessage = [NSString stringWithString:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<LocationsData xmlns=\"http://com.aahg.gymws_ipod/\" />\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>"];
        
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL,WS_ENV,LOCATIONS_URL]];
        soapAction = [NSString stringWithFormat:@"%@",@"http://com.aahg.gymws_ipod/LocationsData"];
    }
    
    if ([_resultType isEqualToString:@"USERLOGIN"]) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<userLogin xmlns=\"http://com.aahg.gymws/\">\n"
                       "<p_usercode>%@</p_usercode>\n"
                       "<p_passWord>%@</p_passWord>\n"
                       "</userLogin>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>", [inputParms valueForKey:@"p_eMail"],[inputParms valueForKey:@"p_passWord"]];     
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL, WS_ENV, LOGIN_URL]];
        
        soapAction = [NSString stringWithFormat:@"%@",@"http://com.aahg.gymws/userLogin"];
    }
    
    theRequest = [NSMutableURLRequest requestWithURL:url];
    msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue:soapAction forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(theConnection)
        webData = [[NSMutableData alloc] init];
    else 
        NSLog(@"theConnection is NULL");
    
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [webData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self processAndReturnXMLMessage];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSString *errmsg = [error description];
    [self showAlertMessage:errmsg];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict   
{
    [parseElement setString:elementName];
    if ([elementName isEqualToString:@"Table"]) {
        resultDataStruct = [[NSMutableDictionary alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([parseElement isEqualToString:@""]==NO) 
        [resultDataStruct setValue:string forKey:parseElement];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    [parseElement setString:@""];
    if ([elementName isEqualToString:@"Table"]) 
    {
        if (resultDataStruct) 
            [dictData addObject:resultDataStruct];
        
    }
}

- (void) showAlertMessage:(NSString *) dispMessage
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:dispMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

- (void) processAndReturnXMLMessage
{
    parseElement = [[NSMutableString alloc] initWithString:@""];	
	NSString *theXML = [self htmlEntityDecode:[[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding]];
    //NSLog(@"the data received %@",theXML);
    if (theXML) {
        if ([theXML isEqualToString:@""]==YES) 
            [self showAlertMessage:@"Web service failure"];
    }
    else
    {
        [self showAlertMessage:@"Web service failure"];
        return;
    }
    /*xmlParser = [[NSXMLParser alloc] initWithData:webData];*/
    @try 
    {
        xmlParser = [[NSXMLParser alloc] initWithData:[theXML dataUsingEncoding:NSUTF8StringEncoding]];
        [xmlParser setDelegate:self];
        [xmlParser setShouldResolveExternalEntities:YES];
        [xmlParser parse];
    }
    @catch (NSException *exception) {
        [self showAlertMessage:[exception description]];
        return;
    }
    
    NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
    [returnInfo setValue:dictData forKey:@"data"];
    //NSLog(@"the returned notification is %@ and return info is %@", _notificationName, returnInfo);
    [[NSNotificationCenter defaultCenter] postNotificationName:_notificationName object:self userInfo:returnInfo];
}

-(NSString *)htmlEntityDecode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    return string;
}

-(NSString *)htmlEntitycode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"];
    string = [string stringByReplacingOccurrencesOfString:@"'" withString:@"&apos;"];
    string = [string stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    string = [string stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    string = [string stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    return string;
}


@end
