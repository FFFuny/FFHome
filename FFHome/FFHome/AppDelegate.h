//
//  AppDelegate.h
//  FFHome
//
//  Created by LiuFei on 2017/2/12.
//  Copyright © 2017年 ff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) BOOL isHalfScreen;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

