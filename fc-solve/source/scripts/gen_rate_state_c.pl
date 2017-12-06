use strict;
use warnings;
use autodie;
use Path::Tiny qw/ path /;

my $type_name  = 'fc_solve_seq_cards_power_type_t';
my $array_name = 'fc_solve_seqs_over_cards_lookup';
my $POWER      = 1.3;
my $TOP        = 2 * 13 * 4 + 1;
my $decl       = "const $type_name ${array_name}[$TOP]";

my @data = ( map { $_**$POWER } ( 0 .. $TOP - 1 ) );

path("rate_state.h")->spew_utf8(<<"EOF");
// This file was generated by gen_rate_state_c.pl .
// Do not modify directly.
#pragma once

typedef double $type_name;
extern $decl;
#define FCS_SEQS_OVER_RENEGADE_POWER(n) ${array_name}[(n)]

EOF

path("rate_state.c")->spew_utf8(<<"EOF");
// This file was generated by gen_rate_state_c.pl .
// Do not modify directly.
#include "rate_state.h"

// This contains the exponents of the first few integers to the power
// of $POWER
$decl =
{
@{[join(", ", @data)]}
};
EOF
