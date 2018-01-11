//
//  DXHDebug.h
//  DHFramework
//
//  Created by daixinhui on 15/9/15.
//  Copyright © 2015年 daixinhui. All rights reserved.
//

#ifndef DXHDebug_h
#define DXHDebug_h

#define DXHDEBUG
#define DXHLOGLEVEL_INFO     10
#define DXHLOGLEVEL_WARNING  3
#define DXHLOGLEVEL_ERROR    1

#ifndef DXHMAXLOGLEVEL

#ifdef DEBUG
#define DXHMAXLOGLEVEL DXHLOGLEVEL_INFO
#else
#define DXHMAXLOGLEVEL DXHLOGLEVEL_ERROR
#endif

#endif

// The general purpose logger. This ignores logging levels.
#ifdef DXHDEBUG
#define DXHDPRINT(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DXHDPRINT(xx, ...)  ((void)0)
#endif

// Prints the current method's name.
#define DXHDPRINTMETHODNAME() DXHDPRINT(@"%s", __PRETTY_FUNCTION__)

// Log-level based logging macros.
#if DXHLOGLEVEL_ERROR <= DXHMAXLOGLEVEL
#define DXHDERROR(xx, ...)  DXHDPRINT(xx, ##__VA_ARGS__)
#else
#define DXHDERROR(xx, ...)  ((void)0)
#endif

#if DXHLOGLEVEL_WARNING <= DXHMAXLOGLEVEL
#define DXHDWARNING(xx, ...)  DXHDPRINT(xx, ##__VA_ARGS__)
#else
#define DXHDWARNING(xx, ...)  ((void)0)
#endif

#if DXHLOGLEVEL_INFO <= DXHMAXLOGLEVEL
#define DXHDINFO(xx, ...)  DXHDPRINT(xx, ##__VA_ARGS__)
#else
#define DXHDINFO(xx, ...)  ((void)0)
#endif

#ifdef DXHDEBUG
#define DXHDCONDITIONLOG(condition, xx, ...) { if ((condition)) { \
DXHDPRINT(xx, ##__VA_ARGS__); \
} \
} ((void)0)
#else
#define DXHDCONDITIONLOG(condition, xx, ...) ((void)0)
#endif


#define DXHAssert(condition, ...)                                       \
do {                                                                      \
if (!(condition)) {                                                     \
[[NSAssertionHandler currentHandler]                                  \
handleFailureInFunction:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] \
file:[NSString stringWithUTF8String:__FILE__]  \
lineNumber:__LINE__                                  \
description:__VA_ARGS__];                             \
}                                                                       \
} while(0)


#endif /* DXHDebug_h */
