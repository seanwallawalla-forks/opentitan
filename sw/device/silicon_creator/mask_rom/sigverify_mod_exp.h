// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#ifndef OPENTITAN_SW_DEVICE_SILICON_CREATOR_MASK_ROM_SIGVERIFY_MOD_EXP_H_
#define OPENTITAN_SW_DEVICE_SILICON_CREATOR_MASK_ROM_SIGVERIFY_MOD_EXP_H_

#include <stdbool.h>
#include <stdint.h>

#include "sw/device/silicon_creator/lib/sigverify_rsa_key.h"

#ifdef __cplusplus
extern "C" {
#endif  // __cplusplus

/**
 * Computes the modular exponentiation of an RSA signature.
 *
 * Given an RSA public key and sig, this function computes sig^e mod n using
 * Montgomery multiplication, where
 * - sig is an RSA signature,
 * - e and n are the exponent and the modulus of the key, respectively.
 *
 * @param key An RSA public key.
 * @param sig Buffer that holds the signature, little-endian.
 * @param result Buffer to write the result to, little-endian.
 * @return True if successful, false otherwise.
 */
// FIXME: Error codes are still under discussion, update after we reach a
// decision.
bool sigverify_mod_exp_ibex(const sigverify_rsa_key_t *key,
                            const sigverify_rsa_buffer_t *sig,
                            sigverify_rsa_buffer_t *result);

#ifdef __cplusplus
}  // extern "C"
#endif  // __cplusplus

#endif  // OPENTITAN_SW_DEVICE_SILICON_CREATOR_MASK_ROM_SIGVERIFY_MOD_EXP_H_
