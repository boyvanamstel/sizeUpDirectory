#import "PRHDirectoryWeigher.h"

#import "NSMetaDataQuery+Synchronous.h"

@implementation PRHDirectoryWeigher

-(unsigned long long)totalSizeOfDirectoryAtURL:(NSURL *)rootURL {
  
  NSMetadataQuery *query = [[NSMetadataQuery alloc] init];
  NSDate *date = [NSDate dateWithNaturalLanguageString:@"1900-01-01 00:00:00"];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"kMDItemFSCreationDate >= %@", date];
  NSArray *results = [query resultsFor:predicate inFolders:[NSSet setWithObject:rootURL.path]];
 
  NSUInteger fileSize = 0;
  for (NSMetadataItem *item in results) {
    fileSize += [[item valueForAttribute:NSMetadataItemFSSizeKey] unsignedIntegerValue];
  }
  
  printf("Warning: this probably isn't correct.\n");
  
  return fileSize;
}

@end
