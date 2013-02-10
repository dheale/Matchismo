//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Dominic Heale on 03/02/2013.
//  Copyright (c) 2013 Dominic Heale. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "deck.h"

@interface CardMatchingGame : NSObject

// this is a convenience initializer and you will get defaults
// of matchBonus 4
//    mismatchPenalty 2
//    flipCost 1
-(id)initWithCardCount:(NSUInteger)cardCount
             usingDeck:(Deck *)deck
        matchingNCards:(int)matchNCards;


// this is the designated initializer
-(id)initWithCardCount:(NSUInteger)cardCount
             usingDeck:(Deck *)deck
        matchingNCards:(int)matchNCards
            matchBonus:(int)matchBonus
       mismatchPenalty:(int)mismatchPenalty
              flipCost:(int)flipCost;

-(void)flipCardAtIndex:(NSUInteger)index;

-(Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic,readonly) int score;

@property (strong, nonatomic) NSMutableArray *moveHistory;

@end
