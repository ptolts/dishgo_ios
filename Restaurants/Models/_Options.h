// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Options.h instead.

#import <CoreData/CoreData.h>


extern const struct OptionsAttributes {
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *max;
	__unsafe_unretained NSString *min;
	__unsafe_unretained NSString *name;
} OptionsAttributes;

extern const struct OptionsRelationships {
	__unsafe_unretained NSString *dish_owner;
	__unsafe_unretained NSString *list;
} OptionsRelationships;

extern const struct OptionsFetchedProperties {
} OptionsFetchedProperties;

@class Dishes;
@class Option;






@interface OptionsID : NSManagedObjectID {}
@end

@interface _Options : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (OptionsID*)objectID;





@property (nonatomic, strong) NSString* id;



//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* max;



@property int16_t maxValue;
- (int16_t)maxValue;
- (void)setMaxValue:(int16_t)value_;

//- (BOOL)validateMax:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* min;



@property int16_t minValue;
- (int16_t)minValue;
- (void)setMinValue:(int16_t)value_;

//- (BOOL)validateMin:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Dishes *dish_owner;

//- (BOOL)validateDish_owner:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *list;

- (NSMutableSet*)listSet;





@end

@interface _Options (CoreDataGeneratedAccessors)

- (void)addList:(NSSet*)value_;
- (void)removeList:(NSSet*)value_;
- (void)addListObject:(Option*)value_;
- (void)removeListObject:(Option*)value_;

@end

@interface _Options (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveId;
- (void)setPrimitiveId:(NSString*)value;




- (NSNumber*)primitiveMax;
- (void)setPrimitiveMax:(NSNumber*)value;

- (int16_t)primitiveMaxValue;
- (void)setPrimitiveMaxValue:(int16_t)value_;




- (NSNumber*)primitiveMin;
- (void)setPrimitiveMin:(NSNumber*)value;

- (int16_t)primitiveMinValue;
- (void)setPrimitiveMinValue:(int16_t)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (Dishes*)primitiveDish_owner;
- (void)setPrimitiveDish_owner:(Dishes*)value;



- (NSMutableSet*)primitiveList;
- (void)setPrimitiveList:(NSMutableSet*)value;


@end
