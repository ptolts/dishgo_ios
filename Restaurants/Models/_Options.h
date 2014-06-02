// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Options.h instead.

#import <CoreData/CoreData.h>


extern const struct OptionsAttributes {
	__unsafe_unretained NSString *advanced;
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *max_selections;
	__unsafe_unretained NSString *min_selections;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *type;
} OptionsAttributes;

extern const struct OptionsRelationships {
	__unsafe_unretained NSString *dish_owner;
	__unsafe_unretained NSString *list;
	__unsafe_unretained NSString *sizes_owner;
} OptionsRelationships;

extern const struct OptionsFetchedProperties {
} OptionsFetchedProperties;

@class Dishes;
@class Option;
@class Dishes;








@interface OptionsID : NSManagedObjectID {}
@end

@interface _Options : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (OptionsID*)objectID;





@property (nonatomic, strong) NSNumber* advanced;



@property BOOL advancedValue;
- (BOOL)advancedValue;
- (void)setAdvancedValue:(BOOL)value_;

//- (BOOL)validateAdvanced:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* id;



//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* max_selections;



@property int16_t max_selectionsValue;
- (int16_t)max_selectionsValue;
- (void)setMax_selectionsValue:(int16_t)value_;

//- (BOOL)validateMax_selections:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* min_selections;



@property int16_t min_selectionsValue;
- (int16_t)min_selectionsValue;
- (void)setMin_selectionsValue:(int16_t)value_;

//- (BOOL)validateMin_selections:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* type;



//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Dishes *dish_owner;

//- (BOOL)validateDish_owner:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSOrderedSet *list;

- (NSMutableOrderedSet*)listSet;




@property (nonatomic, strong) Dishes *sizes_owner;

//- (BOOL)validateSizes_owner:(id*)value_ error:(NSError**)error_;





@end

@interface _Options (CoreDataGeneratedAccessors)

- (void)addList:(NSOrderedSet*)value_;
- (void)removeList:(NSOrderedSet*)value_;
- (void)addListObject:(Option*)value_;
- (void)removeListObject:(Option*)value_;

@end

@interface _Options (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveAdvanced;
- (void)setPrimitiveAdvanced:(NSNumber*)value;

- (BOOL)primitiveAdvancedValue;
- (void)setPrimitiveAdvancedValue:(BOOL)value_;




- (NSString*)primitiveId;
- (void)setPrimitiveId:(NSString*)value;




- (NSNumber*)primitiveMax_selections;
- (void)setPrimitiveMax_selections:(NSNumber*)value;

- (int16_t)primitiveMax_selectionsValue;
- (void)setPrimitiveMax_selectionsValue:(int16_t)value_;




- (NSNumber*)primitiveMin_selections;
- (void)setPrimitiveMin_selections:(NSNumber*)value;

- (int16_t)primitiveMin_selectionsValue;
- (void)setPrimitiveMin_selectionsValue:(int16_t)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitiveType;
- (void)setPrimitiveType:(NSString*)value;





- (Dishes*)primitiveDish_owner;
- (void)setPrimitiveDish_owner:(Dishes*)value;



- (NSMutableOrderedSet*)primitiveList;
- (void)setPrimitiveList:(NSMutableOrderedSet*)value;



- (Dishes*)primitiveSizes_owner;
- (void)setPrimitiveSizes_owner:(Dishes*)value;


@end
