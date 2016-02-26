//
//  NSMetadataQuery+Synchronous.m
//  sizeUpDirectory
//
//  https://github.com/quicksilver/Quicksilver/blob/master/Quicksilver/Code-QuickStepFoundation/NSMetadataQuery%2BSynchronous.m
//

#import "NSMetadataQuery+Synchronous.h"

@implementation NSMetadataQuery (Synchronous)

- (NSArray *)resultsFor:(NSPredicate *)search {
  // search everywhere
  return [self resultsFor:search inFolders:nil];
}

- (NSArray *)resultsFor:(NSPredicate *)search inFolders:(NSSet *)paths {
  if (search == nil) return nil;
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doneSearching:) name:NSMetadataQueryDidFinishGatheringNotification object:nil];
  [self setPredicate:search];
  if (paths) {
    NSMutableArray *pathURLs = [NSMutableArray array];
    for (NSString *path in paths) {
      NSURL *pathURL = [NSURL fileURLWithPath:path];
      [pathURLs addObject:pathURL];
    }
    [self setSearchScopes:pathURLs];
  }
  if ([self startQuery]) {
    CFRunLoopRun();
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSMetadataQueryDidFinishGatheringNotification object:nil];
    return [self results];
  } else {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSMetadataQueryDidFinishGatheringNotification object:nil];
    NSLog(@"query failed to start: %@", search.debugDescription);
  }
  return nil;
}

- (void)doneSearching:(NSNotification *)note {
  [self stopQuery];
  CFRunLoopStop(CFRunLoopGetCurrent());
}

@end