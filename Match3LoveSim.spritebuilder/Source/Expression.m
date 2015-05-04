//
//  Expression.m
//  Match3LoveSim
//
//  Created by Rao Li on 4/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Expression.h"
#import "Orb.h"

@implementation Expression {

    NSDictionary* _Blist, *_Alist;
	BOOL _isA;

    /*
	 @"ヽ(✿ﾟ▽ﾟ)ノ"
	@"(<ゝω・)☆"
	@"(´・ω・)つ旦"
	@"ヾ(●゜▽゜●)♡ "
	 @"(✘﹏✘ა)",
	@"(￣▽￣)"
	@"(=￣ω￣=)"
	@"ヽ(=^･ω･^=)丿"
	@"(ﾉ>ω<)ﾉ"
	 @"o(*ﾟ▽ﾟ*)o"
*/
}

- (void)didLoadFromCCB
{
    _Blist = @{ @(HEAL) : @"(=￣ω￣=)",
        @(PTDOWN) : @"∑(￣□￣;)",
        @(PTDOWNSP) : @"Σ( ° △ °|||)︴",
        @(NEUTRAL) : @"(￣ㄧ￣ )",
        @(PTUP) : @"ヾ(●゜▽゜●)♡ ",
        @(PTUPSP) : @"Σ>―(〃°ω°〃)♡→" };

    _Alist = @{ @(HEAL) : @"(<ゝω・)☆",
        @(PTDOWN) : @" ( ´ﾟДﾟ`)",
        @(PTDOWNSP) : @"Σ(っ|| °Д °;)っ",
        @(NEUTRAL) : @"ヽ(✿ﾟ▽ﾟ)ノ",
        @(PTUP) : @"(*/ω＼*)",
        @(PTUPSP) : @"(ﾉ>ω<)ﾉ" };
}

-(void) changeExp : (MyValue) orbType
{
	if (_isA)
	{
		self.string = _Alist[@(orbType)];
	}
	else
	{
		self.string = _Blist[@(orbType)];
	}
}

@end
