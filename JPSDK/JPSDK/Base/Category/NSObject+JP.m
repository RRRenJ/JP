//
//  NSObject+JP.m
//  JPSDK
//
//  Created by 任敬 on 2021/9/24.
//

#import "NSObject+JP.h"
#import <Foundation/Foundation.h>

@implementation NSObject (JP)

-(BOOL)privateIsKindOfMutableArrayOrSet{
    if ([self isKindOfClass:[NSMutableArray class]] || [self isKindOfClass:[NSMutableOrderedSet class]])
        return YES;
    return NO;
}
-(BOOL)privateIsKindOfArrayOrSet{
    if ([self isKindOfClass:[NSArray class]] || [self isKindOfClass:[NSOrderedSet class]])
        return YES;
    return NO;
}
-(NSUInteger)privateCount{
    if ([self isKindOfClass:[NSArray class]])
        return [(NSArray *)self count];
    else if ([self isKindOfClass:[NSOrderedSet class]])
        return [(NSOrderedSet *)self count];
    return 0;
}
-(void)privateInsertObject:(id)anObject atIndex:(NSUInteger)index{
    if ([self isKindOfClass:[NSMutableArray class]])
        [(NSMutableArray *)self insertObject:anObject atIndex:index];
    else if ([self isKindOfClass:[NSMutableOrderedSet class]])
        [(NSMutableOrderedSet *)self insertObject:anObject atIndex:index];
}
-(void)privateAddObject:(id)anObject{
    if ([self isKindOfClass:[NSMutableArray class]])
        [(NSMutableArray *)self addObject:anObject];
    else if ([self isKindOfClass:[NSMutableOrderedSet class]])
        [(NSMutableOrderedSet *)self addObject:anObject];
}

-(void)privateRemoveObject:(id)anObject{
    if ([self isKindOfClass:[NSMutableArray class]])
        return [(NSMutableArray *)self removeObject:anObject];
    else if ([self isKindOfClass:[NSMutableOrderedSet class]])
        return [(NSMutableOrderedSet *)self removeObject:anObject];
}
-(void)privateRemoveLastObject{
    if ([self isKindOfClass:[NSMutableArray class]])
        return [(NSMutableArray *)self removeLastObject];
    else if ([self isKindOfClass:[NSMutableOrderedSet class]]&&[self privateCount]>0)
        return [(NSMutableOrderedSet *)self removeObjectAtIndex:[self privateCount]-1];
}

-(void)privateRemoveObjectAtIndex:(NSUInteger)index{
    if ([self isKindOfClass:[NSMutableArray class]])
        return [(NSMutableArray *)self removeObjectAtIndex:index];
    else if ([self isKindOfClass:[NSMutableOrderedSet class]])
        return [(NSMutableOrderedSet *)self removeObjectAtIndex:index];
}

-(id)privateObjectAtIndext:(NSUInteger)index{
    if ([self isKindOfClass:[NSArray class]])
        return [(NSArray *)self objectAtIndex:index];
    else if ([self isKindOfClass:[NSOrderedSet class]])
        return [(NSOrderedSet *)self objectAtIndex:index];
    return nil;
}
-(id)privateLastObject{
    if ([self isKindOfClass:[NSArray class]])
        return [(NSArray *)self lastObject];
    else if ([self isKindOfClass:[NSOrderedSet class]])
        return [(NSOrderedSet *)self lastObject];
    return nil;
}

#pragma -
#pragma mark -  公开方法
- (NSObject *)sgrObjectForKey:(NSString *)key;{
    // NSAssert([self isKindOfClass:[NSDictionary class]], @"sagittarius collect error:not a NSDictionary");
    if(key && self &&[self isKindOfClass:[NSDictionary class]]){
        
        return [(NSDictionary *)self objectForKey:key];
    }
    return nil;
}

- (void)sgrInsertObject:(id)anObject atIndex:(NSUInteger)index{
    if(!anObject) return;
    if(self && [self privateIsKindOfMutableArrayOrSet]){
        if(index<[self privateCount]){
            [self privateInsertObject:anObject atIndex:index];
        }else{
            [self privateAddObject:anObject];
        }
    }

}

- (id)sgrOrderSetObjectAtIndex:(int)index{
 
    
    if([self isKindOfClass:[NSOrderedSet class]] &&index< [((NSOrderedSet *)self) count] &&index>=0){
        return [((NSOrderedSet *)self) objectAtIndex:index];
    }
    return nil;
}

- (void)sgrSetObject:(NSObject *)obj forKey:(NSString *)key{
 //  NSAssert([self isKindOfClass:[NSMutableDictionary class]], @"sagittarius collect error:not a NSMutableDictionary");
  if(key && obj && self && [self respondsToSelector:@selector(setObject:forKey:)]){
    [(NSMutableDictionary *)self setObject:obj forKey:key];
  }
}

- (void)sgrRemoveForKey:(NSString *)key{
 // NSAssert(([self isKindOfClass:[NSMutableDictionary class]] ||  [self isKindOfClass:[NSMutableArray class]]),
    //       @"sagittarius collect error:not a NSDictionary or a NSMutableArray");
  if(!(key && self) )return;
  if([self isKindOfClass:[NSMutableDictionary class]]){
    [(NSMutableDictionary *)self removeObjectForKey:key];
  }else if([self privateIsKindOfMutableArrayOrSet]){
    [self privateRemoveObject:key];
  }
}

- (void)sgrRemoveForIndex:(int)index{
    if(self && [self privateIsKindOfMutableArrayOrSet] &&
       index>=0 && index <[self privateCount]){
        [self privateRemoveObjectAtIndex:index];
    }

}


- (id)sgrGetType:(Class )clazz forIndex:(int)i{
  NSObject *obj=[self sgrGetForIndex:i];
  return obj&&[obj isKindOfClass:clazz]?obj:nil;
}

- (id)sgrGetType:(Class )clazz forKey:(NSString *)key{
  NSObject *obj=[self sgrObjectForKey:key];
  return obj&&[obj isKindOfClass:clazz]?obj:nil;
}
- (NSArray *)sgrGetArrayForKey:(NSString *)key{
  NSObject *obj=[self sgrObjectForKey:key];
  return (obj && [obj isKindOfClass:[NSArray class]])?(NSArray *)obj:nil;
}


- (NSDictionary *)sgrGetDictionaryForKey:(NSString *)key{
  NSObject *obj=[self sgrObjectForKey:key];
  return (obj && [obj isKindOfClass:[NSDictionary class]])?(NSDictionary *)obj:nil;
  
}

- (NSDictionary *)sgrGetDictionaryForIndex:(int)index{
  NSObject *obj=[self sgrGetForIndex:index];
  return (obj && [obj isKindOfClass:[NSDictionary class]])?(NSDictionary *)obj:nil;
}

- (NSArray *)sgrGetarrayForIndex:(int)index{
    NSObject *obj = [self sgrGetForIndex:index];
    return (obj && [obj isKindOfClass:[NSArray class]]?(NSArray *)obj:nil);
}

- (NSString *)sgrGetStringForKey:(NSString *)key defaultValue:(NSString *)value{
    NSObject *obj=[self sgrObjectForKey:key];
    return (obj && [obj isKindOfClass:[NSString class]])?(NSString *)obj:value;
}


- (NSString *)sgrFoceGetStringForKey:(NSString *)key defaultValue:(NSString *)value{
    NSObject *obj=[self sgrObjectForKey:key];
    if(!obj || [obj isKindOfClass:[NSNull class]]) return value;
    return ([obj isKindOfClass:[NSString class]])?(NSString *)obj:[obj description];
}

- (NSString *)sgrFGetStringForKey:(NSString *)key{
    NSObject *obj=[self sgrObjectForKey:key];
    if(!obj || [obj isKindOfClass:[NSNull class]]) return nil;
    return ([obj isKindOfClass:[NSString class]])?(NSString *)obj:[obj description];

}

- (NSString *)sgrGetStringForKey:(NSString *)key{
  NSObject *obj=[self sgrObjectForKey:key];
  return (obj && [obj isKindOfClass:[NSString class]])?(NSString *)obj:nil;
}

- (NSNumber *)sgrGetNumberForKey:(NSString *)key{
  NSObject *obj=[self sgrObjectForKey:key];
  return (obj && [obj isKindOfClass:[NSNumber class]])?(NSNumber *)obj:nil;
}
-(float)sgrGetFloatForKey:(NSString *)key{
  NSObject *obj=[self sgrObjectForKey:key];
  if(obj && [obj isKindOfClass:[NSNumber class]]){
    return [(NSNumber *)obj floatValue];
  }
  if(obj && [obj isKindOfClass:[NSString class]]){
    return [(NSString *)obj floatValue];
  }
  return  MINFLOAT;
}

-(int)sgrGetIntForKey:(NSString *)key{
  NSObject *obj=[self sgrObjectForKey:key];
  if(obj && [obj isKindOfClass:[NSNumber class]]){
    return [(NSNumber *)obj intValue];
  }
  if(obj && [obj isKindOfClass:[NSString class]]){
    return [(NSString *)obj intValue];
  }
  return MININT;
}

- (NSObject *)sgrGetForIndex:(int)index{
//  NSAssert([self isKindOfClass:[NSArray class]], @"sagittarius collect error:not a NSArray");
  if(self && [self privateIsKindOfArrayOrSet] &&
     index>=0 && index <[self privateCount]){
    return [self privateObjectAtIndext:index];
  }
  return nil;
}

- (NSNumber *)sgrGetNumberForIndex:(int)index{
    NSObject *obj=[self sgrGetForIndex:index];
    return (obj && [obj isKindOfClass:[NSNumber class]])?(NSNumber *)obj:nil;
}

- (id)sgrlastObjectOfType:(Class)clazz{
    if(self && [self privateIsKindOfArrayOrSet] && [self privateCount]>0) {
        NSObject *obj=[self privateLastObject];
        return (obj&&[obj isKindOfClass:clazz])?obj:nil;
    }else{
        return nil;
    }
}

- (void)sgrRemoveLastObject{
    if(self && [self privateIsKindOfMutableArrayOrSet] && [self privateCount]>0){
        [self privateRemoveLastObject];
    }
}

- (NSString *)sgrGetStringForIndex:(int)index{
  NSObject *obj=[self sgrGetForIndex:index];
  return (obj && [obj isKindOfClass:[NSString class]])?(NSString *)obj:nil;
}

- (void)sgrAddObject:(NSObject *)obj{
  NSAssert([self privateIsKindOfMutableArrayOrSet], @"sagittarius collect error:not a NSMutableArray");
  if(obj && self && [self privateIsKindOfMutableArrayOrSet]){
    [self privateAddObject:obj];
  }
}

@end
