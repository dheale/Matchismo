//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Dominic Heale on 07/02/2013.
//  Copyright (c) 2013 Dominic Heale. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "CardMatchingGame.h"
#import "CardGameMove.h"

@interface CardGameViewController()
-(void)updateUI;

@property (weak, nonatomic) IBOutlet UILabel *resultsOfLastFlipLabel;
@end

@interface SetGameViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@end

@implementation SetGameViewController

-(CardMatchingGame *)game
{
    if (!_game)
    {   _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[[SetCardDeck alloc] init]
                                             matchingNCards:3
                                                 matchBonus:10
                                            mismatchPenalty:3
                                                   flipCost:0];
    }
    return _game;
}

-(void)updateUI
{
    [super updateUI];
    for (UIButton *cardButton in self.cardButtons)
    {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        
        if ([card isKindOfClass:[SetCard class]])
        {
            [cardButton setAttributedTitle:[SetGameViewController attributedStringDescriptionOfCard:(SetCard *) card] forState:UIControlStateSelected];
            [cardButton setAttributedTitle:[SetGameViewController attributedStringDescriptionOfCard:(SetCard *) card] forState:UIControlStateNormal];
            
        }

        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.backgroundColor = cardButton.isSelected ? [UIColor grayColor]:[UIColor whiteColor];
        cardButton.alpha = card.isUnplayable ? 0.0 : 1.0;

    }
    
    
}


+(NSMutableAttributedString *)attributedStringDescriptionOfCard:(SetCard *)card
{
    NSString *symbolString;  // the plain text string we will attribute
      // for the card.symbol
    if ([card.symbol isEqualToString:@"Diamond"])
    {
        symbolString=@"▲";
    }
    else if ([card.symbol isEqualToString:@"Squiggle"])
    {
        symbolString=@"●";
    }
    else if ([card.symbol isEqualToString:@"Oval"])
    {
        symbolString=@"■";
    }

    // repeat the symbol 1, 2 or 3 times - for the card.number
    symbolString = [symbolString stringByPaddingToLength:card.number withString:symbolString startingAtIndex:0];
    
    NSMutableAttributedString *fancyString = [[NSMutableAttributedString alloc] initWithString:symbolString];
    
    NSRange wholeThing = NSMakeRange(0, [symbolString length]);
    
    // set the color - for the card.color
    UIColor *color;
    if ([card.color isEqualToString:@"Red"])
    {
        color = [UIColor redColor];
    }
    else if ([card.color isEqualToString:@"Green"])
    {
        color = [UIColor greenColor];
    }
    else if ([card.color isEqualToString:@"Purple"])
    {
        color = [UIColor purpleColor];
    }
    
    
    // and the alpha for the card.shading
    if ([card.shading isEqualToString:@"Solid"])
    {
        color = [color colorWithAlphaComponent:1.0f];
        [fancyString addAttribute:NSForegroundColorAttributeName value:color range:wholeThing];
    }
    else if ([card.shading isEqualToString:@"Striped"])
    {
        color = [color colorWithAlphaComponent:0.3f];
        [fancyString addAttribute:NSForegroundColorAttributeName value:color range:wholeThing];
    }
    else if ([card.shading isEqualToString:@"Open"])
    {
        [fancyString addAttribute:NSForegroundColorAttributeName value:[color colorWithAlphaComponent:0.02f] range:wholeThing];
        [fancyString addAttribute:NSStrokeColorAttributeName value:color range:wholeThing];
        [fancyString addAttribute:NSStrokeWidthAttributeName value:@4.0f
                            range:wholeThing];
    }

    return fancyString;
}

+(NSAttributedString *)attributedResultSeparator
{
    return [[NSAttributedString alloc] initWithString:@"&"];
}

- (void)updateResultOfLastFlipLabel:(CardGameMove *)move
{
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];

    if (move.moveKind == MoveKindFlipUp)
    {
        [result appendAttributedString:[[NSAttributedString alloc] initWithString:@"Flipped up "]];
    } else if (move.moveKind == MoveKindMatchForPoints)
    {
        [result appendAttributedString:[[NSAttributedString alloc] initWithString:@"Matched "]];
    }
    
    // for each card in the move's cards involved
    
    NSArray *cards = [move cardsThatWereFlipped];
    if ([cards count])
    {
        SetCard *card = cards[0];
        [result appendAttributedString:[SetGameViewController attributedStringDescriptionOfCard:card]];
                   
        for (int i = 1; i < [cards count]; i++) {
            card = cards[i];
            [result appendAttributedString:[SetGameViewController attributedResultSeparator]];
            [result appendAttributedString:[SetGameViewController attributedStringDescriptionOfCard:card]];
        }
    }
    
    
    if (move.moveKind == MoveKindMismatchForPenalty)
    {
        NSString *dontMatchString = [[NSString alloc] initWithFormat:@" don't match! (%d penalty)", move.scoreDeltaForThisMove];
        [result appendAttributedString:[[NSAttributedString alloc] initWithString:dontMatchString]];
         
    } else if (move.moveKind == MoveKindMatchForPoints)
    {
        NSString *forNPoints = [[NSString alloc] initWithFormat:@" for %d points", move.scoreDeltaForThisMove];
        [result appendAttributedString:[[NSAttributedString alloc] initWithString:forNPoints]];
    }
    
    [result addAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:12] }
                    range:NSMakeRange(0, [result length])];
    
    self.resultsOfLastFlipLabel.attributedText = result;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
