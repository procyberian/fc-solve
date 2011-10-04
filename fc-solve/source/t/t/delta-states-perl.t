#!/usr/bin/perl

use strict;
use warnings;

use lib './t/lib';

use Test::More tests => 14;
use Carp;
use Data::Dumper;
use String::ShellQuote;
use File::Spec;
use Test::Differences;

use Games::Solitaire::FC_Solve::DeltaStater;

package main;

{
    # MS Freecell No. 982 Initial state.
    my $delta = Games::Solitaire::FC_Solve::DeltaStater->new(
        {
            init_state_str => <<'EOF'
Foundations: H-0 C-0 D-A S-0 
Freecells:        
: 6D 3C 3H KD 8C 5C
: TC 9C 9H 4S JC 6H 5H
: 2H 2D 3S 5D 9D QS KS
: 6S TD QC KH AS AH 7C
: KC 4H TH 7S 2C 9S
: AC QD 8D QH 3D 8S
: 7H 7D JD JH TS 6C
: 4C 4D 5S 2S JS 8H
EOF
        }
    );

    # TEST
    ok ($delta, 'Object was initialized correctly.');

    $delta->set_derived(
        {
            state_str => <<'EOF'
Foundations: H-0 C-2 D-A S-0 
Freecells:  8D  QD
: 6D 3C 3H KD 8C 5C
: TC 9C 9H 8S
: 2H 2D 3S 5D 9D QS KS QH JC
: 6S TD QC KH AS AH 7C 6H
: KC 4H TH 7S
: 9S
: 7H 7D JD JH TS 6C 5H 4S 3D
: 4C 4D 5S 2S JS 8H
EOF
        }
    );

    # TEST
    eq_or_diff(
        $delta->get_foundations_bits(),
        # Given as an array reference of $num_bits => $bits array refs.
        [
            [4 => 0,], # Hearts
            [4 => 2,], # Clubs
            [4 => 1,], # Diamonds
            [4 => 0,], # Spades
        ],
        'get_foundations_bits works',
    );

    # TEST
    eq_or_diff(
        $delta->get_column_encoding(0),
        [
            [ 3 => 6 ], # Orig len.
            [ 4 => 0 ], # Derived len. 
        ],
        'get_column_lengths_bits() works',
    );

    my $HC = [ 1 => 0, ];
    my $DS = [ 1 => 1, ];
    # TEST
    eq_or_diff(
        $delta->get_column_encoding(1),
        [
            [ 3 => 3 ], # Orig len.
            [ 4 => 1 ], # Derived len. 
            $DS, # 8S
        ],
        'get_column_lengths_bits() works',
    );
    # TEST
    eq_or_diff(
        $delta->get_column_encoding(5),
        [
            [ 3 => 0 ], # Orig len.
            [ 4 => 1 ], # Derived len. 
            [ 6 => (9 | (3 << 4)) ], # 9S
        ],
        'get_column_lengths_bits() works',
    );

    # TEST
    eq_or_diff(
        $delta->get_column_encoding(1),
        [
            [ 3 => 3 ], # Orig len.
            [ 4 => 1 ], # Derived len.
            $DS, # 8S
        ],
        'column No. 1',
    );

    # TEST
    eq_or_diff(
        $delta->get_freecells_encoding(),
        [
            [ 6 => (8 | (2 << 4)) ],  # 8D
            [ 6 => (12 | (2 << 4)) ], # QD
        ],
        'Freecells',
    );
}

{
    my $bit_writer = BitWriter->new;

    # TEST
    ok ($bit_writer, 'Init bit_writer');

    $bit_writer->write(4 => 5);
    $bit_writer->write(2 => 1);

    # TEST
    eq_or_diff(
        $bit_writer->get_bits(),
        chr(5 | (1 << 4)),
        "write() test",
    );
}

{
    my $bit_reader = BitReader->new({ bits => chr(3 | (4 << 3))});

    # TEST
    ok ($bit_reader, 'Init bit_reader');
    
    # TEST
    is ($bit_reader->read(3), 3, 'bit_reader->read(3)');

    # TEST
    is ($bit_reader->read(4), 4, 'bit_reader->read(4)');
}

{
    # MS Freecell No. 982 Initial state.
    my $delta = Games::Solitaire::FC_Solve::DeltaStater->new(
        {
            init_state_str => <<'EOF'
Foundations: H-0 C-0 D-A S-0 
Freecells:        
: 6D 3C 3H KD 8C 5C
: TC 9C 9H 4S JC 6H 5H
: 2H 2D 3S 5D 9D QS KS
: 6S TD QC KH AS AH 7C
: KC 4H TH 7S 2C 9S
: AC QD 8D QH 3D 8S
: 7H 7D JD JH TS 6C
: 4C 4D 5S 2S JS 8H
EOF
        }
    );

    # TEST
    ok ($delta, 'Object was initialized correctly.');

    $delta->set_derived(
        {
            state_str => <<'EOF'
Foundations: H-0 C-2 D-A S-0 
Freecells:  8D  QD
: 6D 3C 3H KD 8C 5C
: TC 9C 9H 8S
: 2H 2D 3S 5D 9D QS KS QH JC
: 6S TD QC KH AS AH 7C 6H
: KC 4H TH 7S
: 9S
: 7H 7D JD JH TS 6C 5H 4S 3D
: 4C 4D 5S 2S JS 8H
EOF
        }
    );

    # TEST
    eq_or_diff(
        scalar($delta->decode($delta->encode())->to_string()),
        <<'EOF',
Foundations: H-0 C-2 D-A S-0 
Freecells:  8D  QD
: 6D 3C 3H KD 8C 5C
: TC 9C 9H 8S
: 2H 2D 3S 5D 9D QS KS QH JC
: 6S TD QC KH AS AH 7C 6H
: KC 4H TH 7S
: 9S
: 7H 7D JD JH TS 6C 5H 4S 3D
: 4C 4D 5S 2S JS 8H
EOF
        'decode() works.',
    );
}

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2011 Shlomi Fish

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

=cut

