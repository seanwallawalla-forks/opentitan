# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

load("//rules:otbn.bzl", "otbn_binary")

package(default_visibility = ["//visibility:public"])

otbn_binary(
    name = "run_rsa_verify_3072_rr_modexp",
    srcs = [
        "//sw/vendor:veri-titan/gen/rsa_verify_3072.s",
        "rsa_verify_3072_rr.s",
        "run_rsa_verify_3072_rr_modexp.s",
    ],
)
