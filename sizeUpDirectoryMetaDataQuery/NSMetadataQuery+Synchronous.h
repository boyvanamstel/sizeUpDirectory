//
//  NSMetadataQuery+Synchronous.h
//  sizeUpDirectory
//
//  https://github.com/quicksilver/Quicksilver/blob/master/Quicksilver/Code-QuickStepFoundation/NSMetadataQuery%2BSynchronous.h
//

#import <Foundation/Foundation.h>

@interface NSMetadataQuery (Synchronous)

/**
 *  Search for items synchronously
 *
 *  @param search The query to use while searching.
 *
 *  @return The discovered items.
 */
- (NSArray *)resultsFor:(NSPredicate *)search;

/**
 *  Search for items synchronously in paths.
 *
 *  @param search The query to use while searching.
 *  @param paths  The paths to search in.
 *
 *  @return The discovered items.
 */
- (NSArray *)resultsFor:(NSPredicate *)search inFolders:(NSSet *)paths;

@end
