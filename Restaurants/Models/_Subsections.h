// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Subsections.h instead.

#import <CoreData/CoreData.h>


extern const struct SubsectionsAttributes {
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *name;
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





@property (nonatomic, strong) NSSet *dishes;

- (NSMutableSet*)dishesSet;




@property (nonatomic, strong) Sections *section_owner;

//- (BOOL)validateSection_owner:(id*)value_ error:(NSError**)error_;





@end

@interface _Subsections (CoreDataGeneratedAccessors)

- (void)addDishes:(NSSet*)value_;
- (void)removeDishes:(NSSet*)value_;
- (void)addDishesObject:(Dishes*)value_;
- (void)removeDishesObject:(Dishes*)value_;

@end

@interface _Subsections (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveId;
- (void)setPrimitiveId:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (NSMutableSet*)primitiveDishes;
- (void)setPrimitiveDishes:(NSMutableSet*)value;



- (Sections*)primitiveSection_owner;
- (void)setPrimitiveSection_owner:(Sections*)value;


@end
