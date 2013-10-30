// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Menu.h instead.

#import <CoreData/CoreData.h>


extern const struct MenuAttributes {
	__unsafe_unretained NSString *id;
} MenuAttributes;

extern const struct MenuRelationships {
	__unsafe_unretained NSString *restaurant_owner;
	__unsafe_unretained NSString *sections;
} MenuRelationships;

extern const struct MenuFetchedProperties {
} MenuFetchedProperties;

@class Restaurant;
@class Sections;



@interface MenuID : NSManagedObjectID {}
@end

@interface _Menu : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (MenuID*)objectID;





@property (nonatomic, strong) NSString* id;



//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Restaurant *restaurant_owner;

//- (BOOL)validateRestaurant_owner:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *sections;

- (NSMutableSet*)sectionsSet;





@end

@interface _Menu (CoreDataGeneratedAccessors)

- (void)addSections:(NSSet*)value_;
- (void)removeSections:(NSSet*)value_;
- (void)addSectionsObject:(Sections*)value_;
- (void)removeSectionsObject:(Sections*)value_;

@end

@interface _Menu (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveId;
- (void)setPrimitiveId:(NSString*)value;





- (Restaurant*)primitiveRestaurant_owner;
- (void)setPrimitiveRestaurant_owner:(Restaurant*)value;



- (NSMutableSet*)primitiveSections;
- (void)setPrimitiveSections:(NSMutableSet*)value;


@end
