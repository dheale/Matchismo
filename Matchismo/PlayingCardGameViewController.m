//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Dominic Heale on 07/02/2013.
//  Copyright (c) 2013 Dominic Heale. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"

@interface CardGameViewController()
-(void)updateUI;
@end

@interface PlayingCardGameViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@end
            
@implementation PlayingCardGameViewController

-(CardMatchingGame *)game
{
    if (!_game)
    {   _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[[PlayingCardDeck alloc] init]
        matchingNCards:2 ];

    }
    return _game;
}

-(void) updateUI
{
    [super updateUI];
        static UIImage* cardBackImage;
        cardBackImage=[UIImage imageNamed:@"cardBackRed.png"];
    
    for (UIButton *cardButton in self.cardButtons)
       {
            Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
            [cardButton setTitle:card.contents forState:UIControlStateSelected];
            [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
    
            [cardButton setImage:(card.isFaceUp ? nil : cardBackImage) forState:UIControlStateNormal];
    
            cardButton.selected = card.isFaceUp;
            cardButton.enabled = !card.isUnplayable;
            cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
    
        }
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
