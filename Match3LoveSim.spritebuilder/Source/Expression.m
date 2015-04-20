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
    _Blist = @{ @(HEAL) : @"(´･_･`)",
        @(PTDOWN) : @"∑(￣□￣;)",
        @(PTDOWNSP) : @"(￣皿￣╬)",
        @(NEUTRAL) : @"(￣ㄧ￣ )",
        @(PTUP) : @"ヾ(●゜▽゜●)♡ ",
        @(PTUPSP) : @"Σ>―(〃°ω°〃)♡→" };

    _Alist = @{ @(HEAL) : @"(´・ω・)つ旦",
        @(PTDOWN) : @" ( ´ﾟДﾟ`)",
        @(PTDOWNSP) : @"(✘﹏✘ა)",
        @(NEUTRAL) : @"ヽ(✿ﾟ▽ﾟ)ノ",
        @(PTUP) : @"o(*ﾟ▽ﾟ*)o",
        @(PTUPSP) : @"(ﾉ>ω<)ﾉ" };
}

-(void)changeExp : (MyValue) orbType
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
