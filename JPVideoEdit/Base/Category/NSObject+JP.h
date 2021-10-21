//
//  NSObject+JP.h
//  JPSDK
//
//  Created by 任敬 on 2021/9/24.
//

#import <Foundation/Foundation.h>

#define MINFLOAT (-MAXFLOAT)
#define MININT (0x80000000)

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (JP)


- (void)sgrInsertObject:(id)anObject atIndex:(NSUInteger)index;

- (NSObject *)sgrObjectForKey:(NSString *)key;

- (void)sgrSetObject:(NSObject *)obj forKey:(NSString *)key;

- (NSString *)sgrGetStringForKey:(NSString *)key;

- (NSNumber *)sgrGetNumberForKey:(NSString *)key;

- (void)sgrRemoveForKey:(NSString *)key;

- (NSObject *)sgrGetForIndex:(int)index;

- (void)sgrAddObject:(NSObject *)obj;

- (NSString *)sgrGetStringForIndex:(int)index;

- (NSArray *)sgrGetArrayForKey:(NSString *)key;

- (NSNumber *)sgrGetNumberForIndex:(int)index;

- (NSArray *)sgrGetarrayForIndex:(int)index;

- (NSDictionary *)sgrGetDictionaryForKey:(NSString *)key;

- (NSDictionary *)sgrGetDictionaryForIndex:(int)index;

-(int)sgrGetIntForKey:(NSString *)key;

-(float)sgrGetFloatForKey:(NSString *)key;

- (id)sgrGetType:(Class )clazz forIndex:(int)i;

- (id)sgrGetType:(Class )clazz forKey:(NSString *)key;

- (id)sgrlastObjectOfType:(Class)clazz;

- (void)sgrRemoveForIndex:(int)index;

- (NSString *)sgrFGetStringForKey:(NSString *)key;

- (void)sgrRemoveLastObject;

- (NSString *)sgrGetStringForKey:(NSString *)key defaultValue:(NSString *)value;


- (NSString *)sgrFoceGetStringForKey:(NSString *)key defaultValue:(NSString *)value;

- (id)sgrOrderSetObjectAtIndex:(int)index;

@end

NS_ASSUME_NONNULL_END
