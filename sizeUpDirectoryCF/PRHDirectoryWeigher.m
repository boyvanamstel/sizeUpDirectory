#import "PRHDirectoryWeigher.h"

#include <sys/stat.h>
#include <dirent.h>

@implementation PRHDirectoryWeigher

-(unsigned long long)totalSizeOfDirectoryAtURL:(NSURL *)rootURL;
{
  
  NSString *folderPath = rootURL.path;
  
  char *dir = (char *)[folderPath fileSystemRepresentation];
  DIR *cd;
  
  struct dirent *dirinfo;
  int lastchar;
  struct stat linfo;
  static unsigned long long totalSize = 0;
  
  cd = opendir(dir);
  
  if (!cd) {
    return 0;
  }
  
  while ((dirinfo = readdir(cd)) != NULL) {
    if (strcmp(dirinfo->d_name, ".") && strcmp(dirinfo->d_name, "..")) {
      char *d_name;
      
      
      d_name = (char*)malloc(strlen(dir)+strlen(dirinfo->d_name)+2);
      
      if (!d_name) {
        //out of memory
        closedir(cd);
        exit(1);
      }
      
      strcpy(d_name, dir);
      lastchar = strlen(dir) - 1;
      if (lastchar >= 0 && dir[lastchar] != '/')
        strcat(d_name, "/");
      strcat(d_name, dirinfo->d_name);
      
      if (lstat(d_name, &linfo) == -1) {
        free(d_name);
        continue;
      }
      if (S_ISDIR(linfo.st_mode)) {
        if (!S_ISLNK(linfo.st_mode))
          [self totalSizeOfDirectoryAtURL:[NSURL fileURLWithPath:[NSString stringWithCString:d_name encoding:NSUTF8StringEncoding]]];
        free(d_name);
      } else {
        if (S_ISREG(linfo.st_mode)) {
          totalSize+=linfo.st_size;
        } else {
          free(d_name);
        }
      }
    }
  }
  
  closedir(cd);
  
  return totalSize;
  
}

@end
