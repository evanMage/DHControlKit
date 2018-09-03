//
//  NSArray+Additions.m
//  DHFramework
//
//  Created by daixinhui on 16/3/16.
//  Copyright © 2016年 daixinhui. All rights reserved.
//

#import "NSArray+Additions.h"
#import "NSData+Additions.h"

@implementation NSArray (Additions)
//******************************* safe *****************************************

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSClassFromString(@"__NSPlaceholderArray") swizzleInstanceMethod:@selector(initWithObjects:count:) with:@selector(safeInitWithObjects:count:)];
        [NSClassFromString(@"__NSArrayI") swizzleInstanceMethod:@selector(objectAtIndex:) with:@selector(safeObjectAtIndex:)];
        [NSClassFromString(@"__NSArray0") swizzleInstanceMethod:@selector(objectAtIndex:) with:@selector(safeZeroObjectAtIndex:)];
        [NSClassFromString(@"__NSSingleObjectArrayI") swizzleInstanceMethod:@selector(objectAtIndex:) with:@selector(safeSingleObjectAtIndex:)];
    });
}

- (instancetype)safeInitWithObjects:(id *)objects count:(NSUInteger)count
{
    NSUInteger newCnt = 0;
    for (NSUInteger i = 0; i < count; i++) {
        if (!objects[i]) {
            break;
        }
        newCnt++;
    }
    return [self safeInitWithObjects:objects count:newCnt];
}

- (id)safeZeroObjectAtIndex:(NSInteger)index
{
    if (index >= self.count) {
        return nil;
    }
    return [self safeZeroObjectAtIndex:index];
}

- (id)safeObjectAtIndex:(NSInteger)index
{
    if (index >= self.count) {
        return nil;
    }
    return [self safeObjectAtIndex:index];
}

- (id)safeSingleObjectAtIndex:(NSInteger)index
{
    if (self.count <= index) {
        return nil;
    }
    return [self safeSingleObjectAtIndex:index];
}

//******************************* safe *****************************************

+ (NSArray *)arrayWithPlistData:(NSData *)plist
{
    if (!plist) {
        return nil;
    }
    NSArray *array = [NSPropertyListSerialization propertyListWithData:plist options:NSPropertyListImmutable format:NULL error:NULL];
    if ([array isKindOfClass:[NSArray class]]) {
        return array;
    }
    return nil;
}

+ (NSArray *)arrayWithPlistString:(NSString *)plist
{
    if (!plist) {
        return nil;
    }
    NSData *data = [plist dataUsingEncoding:NSUTF8StringEncoding];
    return [self arrayWithPlistData:data];
}

- (NSData *)plistData
{
    return [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListBinaryFormat_v1_0 options:kNilOptions error:NULL];
}

- (NSString *)plistString
{
    NSData *xmlData = [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListXMLFormat_v1_0 options:kNilOptions error:NULL];
    if (xmlData) {
        return xmlData.utf8String;
    }
    return nil;
}

- (id)randomObject
{
    if (self.count) {
        return self[arc4random_uniform((u_int32_t)self.count)];
    }
    return nil;
}

- (id)objectOrNilAtindex:(NSUInteger)index
{
    return index < self.count ? self[index] : nil;
}

- (NSString *)jsonStringEncoded
{
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (!error) {
            return json;
        }
    }
    return nil;
}

- (NSString *)jsonPrettyStringEncoded
{
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (!error) {
            return json;
        }
    }
    return nil;
}

@end



@implementation NSMutableArray (Additions)

//******************************* safe *****************************************

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSClassFromString(@"__NSArrayM") swizzleInstanceMethod:@selector(objectAtIndex:) with:@selector(safeObjectAtIndex:)];
        
        [NSClassFromString(@"__NSArrayM") swizzleInstanceMethod:@selector(addObject:) with:@selector(safeAddObject:)];
        
        [NSClassFromString(@"__NSArrayM") swizzleInstanceMethod:@selector(removeObjectAtIndex:) with:@selector(safeRemoveObjectAtIndex:)];
        
        [NSClassFromString(@"__NSArrayM") swizzleInstanceMethod:@selector(replaceObjectAtIndex:withObject:)  with:@selector(safeReplaceObjectAtIndex:withObject:)];
        
        [NSClassFromString(@"__NSArrayM") swizzleInstanceMethod:@selector(removeObjectsInRange:) with:@selector(safeRemoveObjectsInRange:)];
        
        [NSClassFromString(@"__NSArrayM") swizzleInstanceMethod:@selector(insertObject:atIndex:) with:@selector(safeInsertObject:atIndex:)];
    });
}

- (id)safeObjectAtIndex:(NSInteger)index
{
    if (index >= self.count) {
        return nil;
    }
    return [self safeObjectAtIndex:index];
}

- (void)safeAddObject:(id)anObject
{
    if (!anObject) {
        return;
    }
    [self safeAddObject:anObject];
}

- (void)safeRemoveObjectAtIndex:(NSUInteger)index
{
    if (index >= self.count) {
        return;
    }
    [self safeRemoveObjectAtIndex:index];
}

- (void)safeReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    if (index >= self.count || !anObject) {
        return;
    }
    [self safeReplaceObjectAtIndex:index withObject:anObject];
}

- (void)safeRemoveObjectsInRange:(NSRange)range
{
    if (range.length > self.count || range.location > self.count || (range.location + range.length) > self.count) {
        return;
    }
    [self safeRemoveObjectsInRange:range];
}

- (void)safeInsertObject:(id)anObject atIndex:(NSUInteger)index
{
    if (!anObject || index >= self.count) {
        return;
    }
    [self safeInsertObject:anObject atIndex:index];
}

//******************************* safe *****************************************


+ (NSMutableArray *)arrayWithPlistData:(NSData *)plist
{
    if (!plist) {
        return nil;
    }
    NSMutableArray *array = [NSPropertyListSerialization propertyListWithData:plist options:NSPropertyListMutableContainersAndLeaves format:NULL error:NULL];
    if ([array isKindOfClass:[NSMutableArray class]]) {
        return array;
    }
    return nil;
}

+ (NSMutableArray *)arrayWithPlistString:(NSString *)plist
{
    if (!plist) {
        return nil;
    }
    NSData *data = [plist dataUsingEncoding:NSUTF8StringEncoding];
    return [self arrayWithPlistData:data];
}

- (void)removeFirstObject
{
    if (self.count) {
        [self removeObjectAtIndex:0];
    }
}

#pragma mark - clang diagnostic pop

- (id)popFirstObject
{
    id obj = nil;
    if (self.count) {
        obj = self.firstObject;
        [self removeFirstObject];
    }
    return obj;
}

- (id)popLastObject
{
    id obj = nil;
    if (self.count) {
        obj = self.lastObject;
        [self removeLastObject];
    }
    return obj;
}

- (void)appendObject:(id)anObject
{
    [self addObject:anObject];
}

- (void)prependObject:(id)anObject
{
    [self insertObject:anObject atIndex:0];
}

- (void)appendObjects:(NSArray *)objects
{
    if (!objects) {
        return;
    }
    [self addObjectsFromArray:objects];
}

- (void)prependObjects:(NSArray *)objects
{
    if (objects) {
        return;
    }
    NSUInteger i = 0;
    for (id obj in objects) {
        [self insertObject:obj atIndex:i++];
    }
}

- (void)insertObjects:(NSArray *)objects atIndex:(NSUInteger)index
{
    NSUInteger i = index;
    for (id obj in objects) {
        [self insertObjects:obj atIndex:i++];
    }
}

- (void)reverse
{
    NSUInteger count = self.count;
    int mid = floor(count / 2.0);
    for (NSUInteger i = 0; i < mid; i++) {
        [self exchangeObjectAtIndex:i withObjectAtIndex:(count - (i + 1))];
    }
}

- (void)shuffle
{
    for (NSUInteger i = self.count; i > 1; i--) {
        [self exchangeObjectAtIndex:i - 1 withObjectAtIndex:arc4random_uniform((u_int32_t)i)];
    }
}

@end
