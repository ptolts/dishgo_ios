// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Subsections.h instead.

#import <CoreData/CoreData.h>


extern const struct SubsectionsAttributes {
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *position;
} SubsectionsAttributes;

extern const struct SubsectionsRelationships {
	__unsafe_unretained NSString *dishes;
	__unsafe_unretained NSString *section_owner;
} SubsectionsRelationships;

extern const struct SubsectionsFetchedProperties {
} SubsectionsFetchedProperties;

@class Dishes;
@class Sections;





@interface SubsectionsID : NSManagedObjectID {}
@end

@interface _Subsections : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SubsectionsID*)objectID;





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




@property (nonatomic, strong) Sections *section_owner;

//- (BOOL)validateSection_owner:(id*)value_ error:(NSError**)error_;





@end

@interface _Subsections (CoreDataGeneratedAccessors)

- (void)addDishes:(NSOrderedSet*)value_;
- (void)removeDishes:(NSOrderedSet*)value_;
- (void)addDishesObject:(Dishes*)value_;
- (void)removeDishesObject:(Dishes*)value_;

@end

@interface _Subsections (CoreDataGeneratedPrimitiveAccessors)


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



- (Sections*)primitiveSection_owner;
- (void)setPrimitiveSection_owner:(Sections*)value;


@end
