//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Dominic Heale on 03/02/2013.
//  Copyright (c) 2013 Dominic Heale. All rights reserved.
//

#import "CardMatchingGame.h"
#import "CardGameMove.h"

@interface CardMatchingGame()

@property (strong, nonatomic) NSMutableArray *cards;
@property (readwrite, nonatomic) int score;

@property (nonatomic) int matchNCards;
@property (nonatomic) int matchBonus;
@property (nonatomic) int mismatchPenalty;
@property (nonatomic) int flipCost;

@end


@implementation CardMatchingGame

-(NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

-(NSMutableArray *)moveHistory
{
    if (!_moveHistory) _moveHistory = [[NSMutableArray alloc] init];
    return _moveHistory;
}


// this is the designated initializer
-(id)initWithCardCount:(NSUInteger)cardCount
             usingDeck:(Deck *)deck
        matchingNCards:(int)matchNCards
            matchBonus:(int)matchBonus
       mismatchPenalty:(int)mismatchPenalty
              flipCost:(int)flipCost
{
    self = [super init];
    
    if (self)
    {
        for (int i=0; i<cardCount; i++) {
            Card *card = [deck drawRandomCard];
            if (!card) {
                self = nil;
            } else {
                self.cards[i]=card;
            }
        }
        if (matchNCards < [self.cards count])
        {
            self.matchNCards = matchNCards;
        } else {
            self = nil;
        }
        self.matchBonus = matchBonus;
        self.mismatchPenalty = mismatchPenalty;
        self.flipCost = flipCost;
        
    }
    
    return self;
}

// convenience initializer which sets defaults
-(id)initWithCardCount:(NSUInteger)cardCount
             usingDeck:(Deck *)deck
        matchingNCards:(int)matchNCards
{
    return [self initWithCardCount:cardCount
                         usingDeck:deck
                    matchingNCards:matchNCards
                        matchBonus:4
                   mismatchPenalty:2
                          flipCost:1];
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

-(void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    if (card.isUnplayable) return;  // can't click on cards that are already out of the game
    
    if (card.isFaceUp) { // then we are flipping down
        card.faceUp = NO;
        return;
    }
    
    // if we get here, then we are flipping a card up, which costs some points
    int scoreDelta = -self.flipCost;
    
    // a card is "in play" if it is face up and active
    NSMutableArray *otherCardsInPlay = [[NSMutableArray alloc] init];
    NSMutableArray *allCardsInPlay;

    for (Card *otherCard in self.cards) {
        if (otherCard.isFaceUp && !otherCard.isUnplayable) {
            // then that card is 'in play' and part of our 'move'
            [otherCardsInPlay addObject:otherCard];
        }
    }
    
    // of course the card we just played is also 'in play'
    allCardsInPlay = [otherCardsInPlay mutableCopy];
    [allCardsInPlay addObject:card];

    
    CardGameMove *move = nil;

    if ([allCardsInPlay count] == self.matchNCards)
    {
        int matchScore = [card match:otherCardsInPlay];
        
        if (matchScore)
        {
            for (Card *otherCard in allCardsInPlay) otherCard.unplayable = YES;
            
            scoreDelta += matchScore * self.matchBonus;
            move = [[CardGameMove alloc] initWithMoveKind:MoveKindMatchForPoints
                                     CardsThatWereFlipped:allCardsInPlay
                                    scoreDeltaForThisMove:scoreDelta];
        }
        else // it's a mismatch
        {
            // turn the other cards face down
            for (Card *otherCard in otherCardsInPlay) otherCard.faceUp = NO;
            
            scoreDelta -= self.mismatchPenalty;
            move = [[CardGameMove alloc] initWithMoveKind:MoveKindMismatchForPenalty
                                     CardsThatWereFlipped:allCardsInPlay
                                    scoreDeltaForThisMove:scoreDelta];
        }
        
    }
    else  // just flip up a single card, not reached 'N' cards yet
    {
        move = [[CardGameMove alloc] initWithMoveKind:MoveKindFlipUp
                                 CardsThatWereFlipped:allCardsInPlay
                                scoreDeltaForThisMove:scoreDelta];        
    }
    
    [self.moveHistory addObject:move];
    self.score += scoreDelta;
    card.faceUp = !card.isFaceUp;
}

@end