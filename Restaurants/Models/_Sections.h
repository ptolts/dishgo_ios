// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Sections.h instead.

#import <CoreData/CoreData.h>


extern const struct SectionsAttributes {
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *position;
} SectionsAttributes;

extern const struct SectionsRelationships {
	__unsafe_unretained NSString *dishes;
	__unsafe_unretained NSString *restaurant;
} SectionsRelationships;

extern const struct SectionsFetchedProperties {
} SectionsFetchedProperties;

@class Dishes;
@class Restaurant;





@interface SectionsID : NSManagedObjectID {}
@end

@interface _Sections : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SectionsID*)objectID;





@property (nonatomic, strong) NSString* id;



//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* position;



@property int16_t positionValue;
- (int16_t)positionValue;
- (void)setPositionValue:(int16_t)value_;

//- (BOOL)validatePosition:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSOrderedSet *dishes;

- (NSMutableOrderedSet*)dishesSet;




@property (nonatomic, strong) Restaurant *restaurant;

//- (BOOL)validateRestaurant:(id*)value_ error:(NSError**)error_;





@end

@interface _Sections (CoreDataGeneratedAccessors)

- (void)addDishes:(NSOrderedSet*)value_;
- (void)removeDishes:(NSOrderedSet*)value_;
- (void)addDishesObject:(Dishes*)value_;
- (void)removeDishesObject:(Dishes*)value_;

@end

@interface _Sections (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveId;
- (void)setPrimitiveId:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSNumber*)primitivePosition;
- (void)setPrimitivePosition:(NSNumber*)value;

- (int16_t)primitivePositionValue;
- (void)setPrimitivePositionValue:(int16_t)value_;





- (NSMutableOrderedSet*)primitiveDishes;
- (void)setPrimitiveDishes:(NSMutableOrderedSet*)value;



- (Restaurant*)primitiveRestaurant;
- (void)setPrimitiveRestaurant:(Restaurant*)value;


@end
