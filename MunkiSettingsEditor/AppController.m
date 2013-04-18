//
//  AppController.m
//  MunkiSettingsEditor
//
//  Created by Derak Berreyesa on 4/15/13.
//  Copyright (c) 2013 Berreyesa Media LLC. All rights reserved.
//

#import "AppController.h"

@implementation AppController

NSString *plistPath = @"/Library/Preferences/ManagedInstalls.plist";
NSString *writablePath = @"/tmp/ManagedInstalls.plist";

//@synthesize clientIdentifier;

- (void)awakeFromNib {
    
    //Format Text
    //[clientIdentifier setFont:[NSFont fontWithName:@"Herculanum" size:15]];
    [currentClientIdentifier setTextColor:[NSColor redColor]];
    //[label setBackgroundColor:[NSColor blueColor]];
    //[label setDrawsBackground:YES];
    //[label setSelectable:YES];
    //NSString *testString = @"Starting String";
    //[label setStringValue:testString];
    
    //Read Plist
    NSDictionary *plistData = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSString *clientIdentifierText = [plistData objectForKey:@"ClientIdentifier"];
    NSString *softwareRepoURLText = [plistData objectForKey:@"SoftwareRepoURL"];
        
    //Copy Plist file to a writable location
    NSFileManager *filemgr;
    filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath:plistPath] == YES)
        NSLog (@"File exists");
    else
        NSLog (@"File not found");
    
    if ([filemgr copyItemAtPath:plistPath toPath:writablePath error: NULL]  == YES)
        NSLog (@"Copy successful");
    else
        NSLog (@"Copy failed");


    /*
    //Copy back to /Library/Preferences
    if ([filemgr copyItemAtPath:writablePath toPath:plistPath error: NULL]  == YES)
        NSLog (@"Copy back successful");
    else
        NSLog (@"Copy back failed");
     */


    //Display current ClientIdentifier
    [currentClientIdentifier setStringValue:clientIdentifierText];
    
    //Display current softwareRepoURL
    [softwareRepoURL setStringValue:softwareRepoURLText];
    
}

/*
- (BOOL)runProcessAsAdministrator:(NSString*)scriptPath
                     withArguments:(NSArray *)arguments
                            output:(NSString **)output
                  errorDescription:(NSString **)errorDescription {
    
    NSString * allArgs = [arguments componentsJoinedByString:@" "];
    NSString * fullScript = [NSString stringWithFormat:@"%@ %@", scriptPath, allArgs];
    
    NSDictionary *errorInfo = [NSDictionary new];
    NSString *script =  [NSString stringWithFormat:@"do shell script \"%@\" with administrator privileges", fullScript];
    
    NSAppleScript *appleScript = [[NSAppleScript new] initWithSource:script];
    NSAppleEventDescriptor * eventResult = [appleScript executeAndReturnError:&errorInfo];
    
    // Check errorInfo
    if (! eventResult)
    {
        // Describe common errors
        *errorDescription = nil;
        if ([errorInfo valueForKey:NSAppleScriptErrorNumber])
        {
            NSNumber * errorNumber = (NSNumber *)[errorInfo valueForKey:NSAppleScriptErrorNumber];
            if ([errorNumber intValue] == -128)
                *errorDescription = @"The administrator password is required to do this.";
        }
        
        // Set error message from provided message
        if (*errorDescription == nil)
        {
            if ([errorInfo valueForKey:NSAppleScriptErrorMessage])
                *errorDescription =  (NSString *)[errorInfo valueForKey:NSAppleScriptErrorMessage];
        }
        
        return NO;
    }
    else
    {
        // Set output to the AppleScript's output
        *output = [eventResult stringValue];
        
        return YES;
    }
}
*/


- (IBAction)showClientIdentifier:(id)sender {
    
    //Get value from Text Field
    NSString *newClientIdentifier = [clientIdentifier stringValue];
    
    //Read Plist
    NSMutableDictionary* plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:writablePath];
    
    //Write ClientIdentifier to plist
    [plistDict setObject:[NSString stringWithString:newClientIdentifier] forKey:@"ClientIdentifier"];
    [plistDict writeToFile:writablePath atomically: YES];
    
    //newClientIdentifier = @"Updated...";
    [clientIdentifier setStringValue:@""];
    
    [currentClientIdentifier setStringValue:newClientIdentifier];

    
    //Copy back to /Library/Preferences
    //NSArray *arguments = [NSArray arrayWithObjects:@"-un", nil];
    //NSArray *arguments = [NSArray arrayWithObjects:@"/Library/Preferences/hi.txt", nil];
    NSArray *arguments = [NSArray arrayWithObjects:writablePath, plistPath, nil];
    NSString *output;
    NSString *errorDescription;
    NSString *scriptPath = @"/bin/cp";
    
    NSString *allArgs = [arguments componentsJoinedByString:@" "];
    NSString *fullScript = [NSString stringWithFormat:@"%@ %@", scriptPath, allArgs];
    
    NSDictionary *errorInfo = [NSDictionary new];
    NSString *script =  [NSString stringWithFormat:@"do shell script \"%@\" with administrator privileges", fullScript];
    
    NSAppleScript *appleScript = [[NSAppleScript new] initWithSource:script];
    NSAppleEventDescriptor * eventResult = [appleScript executeAndReturnError:&errorInfo];
    
    // Check errorInfo
    if (! eventResult)
    {
        // Describe common errors
        errorDescription = nil;
        if ([errorInfo valueForKey:NSAppleScriptErrorNumber])
        {
            NSNumber * errorNumber = (NSNumber *)[errorInfo valueForKey:NSAppleScriptErrorNumber];
            if ([errorNumber intValue] == -128)
                errorDescription = @"The administrator password is required to do this.";
        }
        
        // Set error message from provided message
        if (errorDescription == nil)
        {
            if ([errorInfo valueForKey:NSAppleScriptErrorMessage])
                errorDescription =  (NSString *)[errorInfo valueForKey:NSAppleScriptErrorMessage];
        }
        
        NSLog(@"script failure: %@",errorDescription);
    }
    else
    {
        // Set output to the AppleScript's output
        output = [eventResult stringValue];
        NSLog(@"script success!");
    }
    
    //Read original plist and display value 
    NSDictionary *plistData = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSString *clientIdentifierText = [plistData objectForKey:@"ClientIdentifier"];
    
    [currentClientIdentifier setStringValue:clientIdentifierText];
    
    
    //Remove tmp file
    /*
    NSFileManager *filemgr;
    filemgr = [NSFileManager defaultManager];
    if ([filemgr removeItemAtPath:writablePath error: NULL]  == YES)
        NSLog (@"Remove tmp successful");
    else
        NSLog (@"Remove tmp failed");
     */



}

@end
