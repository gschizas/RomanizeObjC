//
//  main.m
//  RomanizeObjC
//
//  Created by George Schizas on 06/11/2016.
//  Copyright © 2016 George Schizas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "romanize.h"

void TestRomanize(NSString *arg1, NSString *arg2) {
    NSString *romanizedText = romanize(arg1);
    BOOL romanizeOk = [romanizedText isEqualToString:arg2];
    if (!romanizeOk) {
        NSLog(@"Error romanizing %@. Expecting %@, got %@", arg1, arg2, romanizedText);
        // assert(NO);
    } else {
        NSLog(@"Success romanizing %@. Got %@", arg1, romanizedText);
    }
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        TestRomanize(@"Γειά σου κόσμε!", @"Geia sou kosme!");
        TestRomanize(@"Γιώργος Σχίζας", @"Giorgos Schizas");
        TestRomanize(@"Θανάσης ΘΑΝΑΣΗΣ θΑνάσης ΘΑνάσης", @"Thanasis THANASIS thAnasis THAnasis");
        TestRomanize(@"Αντώνης Ψαράς με ψάρια", @"Antonis Psaras me psaria");
        TestRomanize(@"Αυγά αύριο παύση", @"Avga avrio pafsi");
        TestRomanize(@"Άγγελος αρχάγγελος", @"Angelos archangelos");
        TestRomanize(@"Ξάδελφος εξ αγχιστείας", @"Xadelfos ex anchisteias");
        TestRomanize(@"Ακούμπα κάτω τα μπαούλα Γιακούμπ", @"Akoumpa kato ta baoula Giakoub");
        TestRomanize(@"Ζεύξη Ρίου-Αντιρρίου", @"Zefxi Riou-Antirriou");
        TestRomanize(@"μεταγραφή", @"metagrafi");
        TestRomanize(@"Ούτε το αγγούρι ούτε η αγκινάρα γράφονται με γξ", @"Oute to angouri oute i agkinara grafontai me nx");
        TestRomanize(@"ΟΥΡΑΝΟΣ Ουρανός ουρανός οϋρανός", @"OURANOS Ouranos ouranos oyranos");
        TestRomanize(@"Έχω ελέγξει το 100% της μεθόδου", @"Echo elenxei to 100% tis methodou");
    }
    return 0;
}
