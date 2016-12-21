/*
 * This file is part of Freecell Solver. It is subject to the license terms in
 * the COPYING.txt file found in the top-level directory of this distribution
 * and at http://fc-solve.shlomifish.org/docs/distro/COPYING.html . No part of
 * Freecell Solver, including this file, may be copied, modified, propagated,
 * or distributed except according to the terms contained in the COPYING file.
 *
 * Copyright (c) 2000 Shlomi Fish
 */
/*
 * card.c - functions to convert cards and card components to and from
 * their user representation.
 */

#include "dll_thunk.h"
#include <string.h>
#include <ctype.h>
#include "state.h"
#include "p2u_rank.h"

#ifdef DEFINE_fc_solve_empty_card
DEFINE_fc_solve_empty_card();
#endif

/*
 * Converts a suit to its user representation.
 *
 * */
static inline void fc_solve_p2u_suit(const int suit, char *str)
{
    *(str++) = "HCDS"[suit];
    *(str) = '\0';
}

/*
 * Convert an entire card to its user representation.
 *
 * */
void fc_solve_card_stringify(
    const fcs_card_t card, char *const str PASS_T(const fcs_bool_t t))
{
    fc_solve_p2u_rank(fcs_card_rank(card), str PASS_T(t));
    fc_solve_p2u_suit(fcs_card_suit(card), strchr(str, '\0'));
}
