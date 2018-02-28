//
//  DXHObjectSingeton.h
//  DHControlKit
//
//  Created by 代新辉 on 2018/2/26.
//  Copyright © 2018年 代新辉. All rights reserved.
//

#ifndef DXHObjectSingeton_h
#define DXHObjectSingeton_h

#define DXH_OBJECT_SINGLETON_BOILERPLATE(_object_name_, _shared_obj_name_)    \
static _object_name_ *z##_shared_obj_name_ = nil;    \
+ (_object_name_ *)_shared_obj_name_ {  \
@synchronized(self) {   \
if (z##_shared_obj_name_ == nil) {  \
static dispatch_once_t done;    \
dispatch_once(&done, ^{ z##_shared_obj_name_ = [[self alloc] init]; }); \
/* Note that 'self' may not be the same as _object_name_ *
first assignment done in allocWithZone but we must reassign in case init fails
z##_shared_obj_name_ = [[self alloc] init];
NSAssert((z##_shared_obj_name_ != nil), @"didn't catch singleton allocation");
*/  \
}   \
}   \
return z##_shared_obj_name_;    \
}   \
+ (id)allocWithZone:(NSZone *)zone {    \
@synchronized(self) {   \
if (z##_shared_obj_name_ == nil) {  \
z##_shared_obj_name_ = [super allocWithZone:zone];  \
return z##_shared_obj_name_;    \
}   \
}   \
/* We can't return the shared instance, because it's been init'd */ \
/*NSAssert(NO, @"use the singleton API, not alloc+init");    */\
return nil;     \
}   \

#endif /* DXHObjectSingeton_h */
