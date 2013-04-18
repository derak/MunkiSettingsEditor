//
//  AppController.h
//  MunkiSettingsEditor
//
//  Created by Derak Berreyesa on 4/15/13.
//  Copyright (c) 2013 Berreyesa Media LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppController : NSObject{
//@private
    IBOutlet NSTextField *clientIdentifier;
    IBOutlet NSTextField *currentClientIdentifier;
    IBOutlet NSTextField *softwareRepoURL;
    

}

/* - (BOOL)runProcessAsAdministrator:(NSString*)scriptPath
                    withArguments:(NSArray *)arguments
                           output:(NSString **)output
                 errorDescription:(NSString **)errorDescription; */


- (IBAction)showClientIdentifier:(id)sender;


@end
