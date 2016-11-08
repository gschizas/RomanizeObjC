//
//  romanize.m
//  RomanizeObjC
//
//  Created by George Schizas on 06/11/2016.
//  Copyright © 2016 George Schizas. All rights reserved.
//

#import <Foundation/Foundation.h>

const NSString *simple_translation_greek = @"άβδέζήιίϊΐκλνξόπρσςτυύϋΰφωώ";
const NSString *simple_translation_latin = @"avdeziiiiiklnxoprsstyyyyfoo";
const NSString *digraph_translation_greek = @"θχψ";
const NSString *digraph_translation_latin = @"thchps";
const NSString *digraph_ypsilon_greek = @"αεη";
const NSString *digraph_ypsilon_latin = @"aei";
const NSString *digraph_ypsilon_beta = @"βγδζλμνραάεέηήιίϊΐοόυύϋΰωώ";
const NSString *digraph_ypsilon_phi = @"θκξπστφχψ";

NSUInteger charIn(const NSString *haystack, unichar needle) {
    NSCharacterSet *needleSet = [NSCharacterSet characterSetWithRange:NSMakeRange(needle, 1)];
    NSRange result = [haystack rangeOfCharacterFromSet:needleSet];
    return result.location;
}

BOOL isWhitespace(unichar needle) {
    if (needle == 0) return YES;
    return [[NSCharacterSet whitespaceCharacterSet] characterIsMember:needle];
}

unichar uppercase(unichar input) {
    unichar inputCharacters[] = {input};

    NSString *inputText = [NSString
            stringWithCharacters:inputCharacters
                          length:sizeof inputCharacters / sizeof *inputCharacters];
    unichar result = [[inputText uppercaseString] characterAtIndex:0];
    return result;
}

unichar lowercase(unichar input) {
    unichar inputCharacters[] = {input};

    NSString *inputText = [NSString
            stringWithCharacters:inputCharacters
                          length:sizeof inputCharacters / sizeof *inputCharacters];
    unichar result = [[inputText lowercaseString] characterAtIndex:0];
    return result;
}


NSString *romanize(NSString *greekText) {
    NSUInteger greekLength = greekText.length;
    NSMutableString *result = [NSMutableString string];
    unichar letter, prevLetter, nextLetter, thirdLetter;
    NSMutableString *newLetter = [NSMutableString string];
    BOOL is_upper, is_upper2;

    NSUInteger cursor = 0;
    while (cursor < greekLength) {
        [newLetter setString:@""];
        letter = [greekText characterAtIndex:cursor];

        prevLetter = (unichar) ((cursor > 0) ? [greekText characterAtIndex:(cursor - 1)] : 0);
        nextLetter = (unichar) ((cursor < greekLength - 1) ? [greekText characterAtIndex:(cursor + 1)] : 0);
        thirdLetter = (unichar) ((cursor < greekLength - 2) ? [greekText characterAtIndex:(cursor + 2)] : 0);

        is_upper = uppercase(letter) == letter;
        is_upper2 = uppercase(nextLetter) == nextLetter;

        letter = lowercase(letter);
        prevLetter = lowercase(prevLetter);
        nextLetter = lowercase(nextLetter);
        thirdLetter = lowercase(thirdLetter);


        NSUInteger letterPosition = charIn(simple_translation_greek, letter);
        NSUInteger diphthongIndex = charIn(digraph_translation_greek, letter);
        NSUInteger ypsilonPosition = charIn(digraph_ypsilon_greek, letter);
        if (letterPosition != NSNotFound) {
            [newLetter appendString:[simple_translation_latin substringWithRange:NSMakeRange(letterPosition, 1)]];
        } else if (diphthongIndex != NSNotFound) {
            [newLetter appendString:[digraph_translation_latin substringWithRange:NSMakeRange(diphthongIndex * 2, 2)]];
        } else if (ypsilonPosition != NSNotFound) {
            [newLetter appendString:[digraph_ypsilon_latin substringWithRange:NSMakeRange(ypsilonPosition, 1)]];
            if (nextLetter == L'υ' || nextLetter == L'ύ') {
                if (charIn(digraph_ypsilon_beta, thirdLetter) != NSNotFound) {
                    [newLetter appendString:@"v"];
                    cursor++;
                } else if (charIn(digraph_ypsilon_phi, thirdLetter) != NSNotFound) {
                    [newLetter appendString:@"f"];
                    cursor++;
                }
            }
        } else if (letter == L'γ') {
            switch (nextLetter) {
                case L'γ':
                    [newLetter appendString:@"ng"];
                    cursor++;
                    break;
                case L'ξ':
                    [newLetter appendString:@"nx"];
                    cursor++;
                    break;
                case L'χ':
                    [newLetter appendString:@"nch"];
                    cursor++;
                    break;
                default:
                    [newLetter appendString:@"g"];
            }
        } else if (letter == L'μ') {
            if (nextLetter == L'π') {
                BOOL isLetterWhitespace = isWhitespace(prevLetter) || isWhitespace(thirdLetter);
                [newLetter appendString:isLetterWhitespace ? @"b" : @"mp"];
                cursor++;
            } else {
                [newLetter appendString:@"m"];
            }
        } else if (letter == L'ο') {
            [newLetter appendString:@"o"];
            if (nextLetter == L'υ' || nextLetter == L'ύ') {
                [newLetter appendString:@"u"];
                cursor++;
            }
        } else {
            unichar letterStringBuff[] = {letter};
            NSString *letterString = [NSString
                    stringWithCharacters:letterStringBuff
                                  length:sizeof letterStringBuff / sizeof *letterStringBuff];
            [newLetter appendString:letterString]; //letter
        }

        // fix case
        if (is_upper) {
            NSString *c1 = [[newLetter substringToIndex:1] uppercaseString];
            NSString *c2;
            if (is_upper2) {
                c2 = [[newLetter substringFromIndex:1] uppercaseString];
            } else {
                c2 = [newLetter substringFromIndex:1];
            }
            [newLetter setString:[c1 stringByAppendingString:c2]];
        }

        [result appendString:newLetter];
        cursor++;
    }
    return result;
}
