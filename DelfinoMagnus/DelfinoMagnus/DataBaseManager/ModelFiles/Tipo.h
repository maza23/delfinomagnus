//
//  Tipo.h
//  DelfinoMagnus
//
//  Created by Avadesh Kumar on 5/11/14.
//  Copyright (c) 2014 Delfino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Tipo : NSManagedObject

@property (nonatomic, retain) NSString * tipoId;
@property (nonatomic, retain) NSString * name;

@end
