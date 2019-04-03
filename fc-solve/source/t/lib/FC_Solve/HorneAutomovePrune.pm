package FC_Solve::HorneAutomovePrune;

use strict;
use warnings;

my $calc_foundation_to_put_card_on = sub {
    my $running_state = shift;
    my $card          = shift;

DECKS_LOOP:
    for my $deck ( 0 .. $running_state->num_decks() - 1 )
    {
        if ( $running_state->get_foundation_value( $card->suit(), $deck ) ==
            $card->rank() - 1 )
        {
            for my $other_deck_idx (
                0 .. ( ( $running_state->num_decks() << 2 ) - 1 ) )
            {
                if (
                    $running_state->get_foundation_value(
                        $card->get_suits_seq->[ $other_deck_idx % 4 ],
                        ( $other_deck_idx >> 2 ),
                    ) < $card->rank() - 2 - (
                        (
                            $card->color_for_suit(
                                $card->get_suits_seq->[ $other_deck_idx % 4 ]
                            ) eq $card->color()
                        ) ? 1 : 0
                    )
                    )
                {
                    next DECKS_LOOP;
                }
            }
            return [ $card->suit(), $deck ];
        }
    }
    return;
};

sub _perform_and_output_move
{
    my ( $running_state, $move_s, $out_running_state, $out_move ) = @_;
    $out_move->($move_s);
    $running_state->verify_and_perform_move(
        Games::Solitaire::Verify::Move->new(
            {
                fcs_string => $move_s,
                game       => $running_state->_variant(),
            },
        )
    );
    $out_running_state->($running_state);

    return;
}

sub _check_for_prune_move
{
    my ( $running_state, $card, $prune_move, $out_running_state, $out_move ) =
        @_;

    if ( defined($card) )
    {
        my $f = $calc_foundation_to_put_card_on->( $running_state, $card );

        if ( defined($f) )
        {
            _perform_and_output_move( $running_state, $prune_move,
                $out_running_state, $out_move );
            return 1;
        }
    }

    return 0;
}

sub _prune_all
{
    my ( $running_state, $out_running_state, $out_move ) = @_;
PRUNE:
    while (1)
    {
        my $num_moved = 0;
        foreach my $idx ( 0 .. ( $running_state->num_columns() - 1 ) )
        {
            my $col = $running_state->get_column($idx);

            $num_moved += _check_for_prune_move(
                $running_state,
                scalar( $col->len() ? $col->top() : undef() ),
                "Move a card from stack $idx to the foundations",
                $out_running_state,
                $out_move,
            );
        }

        foreach my $idx ( 0 .. ( $running_state->num_freecells() - 1 ) )
        {
            $num_moved += _check_for_prune_move(
                $running_state,
                $running_state->get_freecell($idx),
                "Move a card from freecell $idx to the foundations",
                $out_running_state,
                $out_move,
            );
        }
        last PRUNE if $num_moved == 0;
    }
}

1;