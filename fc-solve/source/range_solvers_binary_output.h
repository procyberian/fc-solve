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
 * range_solvers_binary_output.h - header file for range solvers binary
 * output.
 */
#pragma once

#ifdef __cplusplus
extern "C" {
#endif

#include <stdio.h>

#include "rinutils.h"
#include "fcs_cl.h"

typedef struct
{
    FILE *fh;
    char *buffer;
    char *buffer_end;
    char *ptr;
    const char *filename;
} binary_output_t;

const binary_output_t INIT_BINARY_OUTPUT = {.filename = NULL};

#define BINARY_OUTPUT_NUM_INTS 16
#define BINARY_OUTPUT_BUF_SIZE (sizeof(int) * BINARY_OUTPUT_NUM_INTS)
#define SIZE_INT 4

static GCC_INLINE void write_me(binary_output_t *const bin)
{
    fwrite(bin->buffer, 1, (size_t)(bin->ptr - bin->buffer), bin->fh);
    fflush(bin->fh);
}

static void print_int(binary_output_t *const bin, int val)
{
    if (!bin->fh)
    {
        return;
    }
    unsigned char *const buffer = (unsigned char *const)bin->ptr;
    for (int p = 0; p < SIZE_INT; p++)
    {
        buffer[p] = (unsigned char)(val & 0xFF);
        val >>= 8;
    }
    bin->ptr += SIZE_INT;
    if (bin->ptr == bin->buffer_end)
    {
        write_me(bin);
        /* Reset ptr to the beginning */
        bin->ptr = bin->buffer;
    }
}

static GCC_INLINE void bin_close(binary_output_t *const bin)
{
    if (bin->filename)
    {
        write_me(bin);
        fclose(bin->fh);
        bin->fh = NULL;
        bin->filename = NULL;
    }
}

static GCC_INLINE fcs_bool_t read_int(FILE *const f, long long *const dest)
{
    unsigned char buffer[SIZE_INT];
    if (fread(buffer, 1, SIZE_INT, f) != SIZE_INT)
    {
        return TRUE;
    }
    *dest = (buffer[0] +
             ((buffer[1] + ((buffer[2] + ((buffer[3]) << 8)) << 8)) << 8));

    return FALSE;
}

static void read_int_wrapper(FILE *const in, long long *const var)
{
    if (read_int(in, var))
    {
        fprintf(stderr, "%s",
            "Output file is too short to deduce the configuration!\n");
        exit(-1);
    }
}

static GCC_INLINE void bin_init(binary_output_t *const bin,
    long long *const start_board_ptr, long long *const end_board_ptr,
    fcs_int_limit_t *const total_iterations_limit_per_board_ptr)
{
    if (bin->filename)
    {
        FILE *in;

        bin->buffer = malloc(BINARY_OUTPUT_BUF_SIZE);
        bin->ptr = bin->buffer;
        bin->buffer_end = bin->buffer + BINARY_OUTPUT_BUF_SIZE;

        in = fopen(bin->filename, "rb");
        if (in == NULL)
        {
            bin->fh = fopen(bin->filename, "wb");
            if (!bin->fh)
            {
                fprintf(stderr, "Could not open \"%s\" for writing!\n",
                    bin->filename);
                exit(-1);
            }

            print_int(bin, *start_board_ptr);
            print_int(bin, *end_board_ptr);
            print_int(bin, (int)(*total_iterations_limit_per_board_ptr));
        }
        else
        {
            read_int_wrapper(in, start_board_ptr);
            read_int_wrapper(in, end_board_ptr);
            {
                long long val;
                read_int_wrapper(in, &val);
                *total_iterations_limit_per_board_ptr = (fcs_int_limit_t)val;
            }

            fseek(in, 0, SEEK_END);
            const long file_len = ftell(in);
            if (file_len % 4 != 0)
            {
                fprintf(stderr, "%s",
                    "Output file has an invalid length. Terminating.\n");
                exit(-1);
            }
            *start_board_ptr += (file_len - 12) / 4;
            if (*start_board_ptr >= *end_board_ptr)
            {
                fprintf(stderr, "%s",
                    "Output file was already finished being generated.\n");
                exit(-1);
            }
            fclose(in);
            bin->fh = fopen(bin->filename, "ab");
            if (!bin->fh)
            {
                fprintf(stderr, "Could not open \"%s\" for writing!\n",
                    bin->filename);
                exit(-1);
            }
        }
    }
    else
    {
        bin->fh = NULL;
        bin->buffer = bin->ptr = bin->buffer_end = NULL;
    }
}

#ifdef __cplusplus
}
#endif
