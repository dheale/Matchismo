//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Dominic Heale on 30/01/2013.
//  Copyright (c) 2013 Dominic Heale. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "CardGameMove.h"
#import "Deck.h"

@interface CardGameViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;

@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultsOfLastFlipLabel;
@property (nonatomic) BOOL gameInProgress;

-(void)updateResultOfLastFlipLabel:(CardGameMove *)move;
- (IBAction)deal:(id)sender;

@property (weak, nonatomic) IBOutlet UISlider *historySlider;
//@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeSelector;
@end


@implementation CardGameViewController

//-(CardMatchingGame *)game
//{
//    if (!_game)
//{   _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
//                                                  usingDeck:[self deckToUse]
//                                             matchingNCards:[self matchNCards]];
//
//    }
//    return _game;//
//}

-(void) updateUI
{
    //    static UIImage* cardBackImage;
    //    cardBackImage=[UIImage imageNamed:@"cardBackRed.png"];
    
    //for (UIButton *cardButton in self.cardButtons)
    //   {
    //        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
    //        [cardButton setTitle:card.contents forState:UIControlStateSelected];
    //        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
    
    //        [cardButton setImage:(card.isFaceUp ? nil : cardBackImage) forState:UIControlStateNormal];
    
    //        cardButton.selected = card.isFaceUp;
    //        cardButton.enabled = !card.isUnplayable;
    //        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
    
    //    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    
    self.historySlider.maximumValue = [self.game.moveHistory count]-1;
    
    if (self.historySlider.value == self.historySlider.maximumValue || self.historySlider.maximumValue == 0.0f)
    {
        [self updateResultOfLastFlipLabel:[self.game.moveHistory lastObject]];
        self.resultsOfLastFlipLabel.alpha = 1.0;
    }
    else
    {
        if ([self.game.moveHistory count])
        {
            int intValue = roundl(self.historySlider.value);

            [self updateResultOfLastFlipLabel:self.game.moveHistory[intValue]];
//            
//            self.resultsOfLastFlipLabel.text =            
//            [self.game.moveHistory[intValue] descriptionOfMove];
//            
            self.resultsOfLastFlipLabel.alpha = 0.3;
        }
    }
}

- (IBAction)historySliderValueChanged:(UISlider *)sender {
    int intValue = roundl([sender value]); // Rounds float to an integer
    static float oldIntValue = 0.0f;
    if (intValue != oldIntValue)
    {
        [self updateUI];
        oldIntValue = intValue;
    }
    
    [sender setValue:(float)intValue];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    // deal a new game - this clears the result label
    // otherwise we can't set this string in UI builder in XCode
    // and that makes it harder to see
    [self deal:self];
}

-(IBAction)deal:(id)sender
{
    self.game=nil;
    self.gameInProgress=NO;
    self.flipCount=0;
    self.resultsOfLastFlipLabel.text=nil;
    [self updateUI];
}

-(void)setGameInProgress:(BOOL)gameInProgress
{
    _gameInProgress=gameInProgress;
}

-(void) setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

// This is the default thing to do for card matching games - just use a NSString here
// but Set Game will override it and set a NSAttributed string
- (void)updateResultOfLastFlipLabel:(CardGameMove *)move
{
    self.resultsOfLastFlipLabel.text = [move descriptionOfMove];
}


- (IBAction)flipCard:(UIButton *)sender
{
    self.gameInProgress = YES;

    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];

    self.historySlider.maximumValue = [self.game.moveHistory count]-1;
    self.historySlider.value = self.historySlider.maximumValue;

    self.flipCount++;
    [self updateUI];
}

@end
