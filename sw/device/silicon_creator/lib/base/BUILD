# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
load("//rules:opentitan.bzl", "OPENTITAN_CPU")

package(default_visibility = ["//visibility:public"])

exports_files(["static_critical.ld"])

cc_library(
    name = "mock_csr",
    testonly = True,
    srcs = ["mock_csr.cc"],
    hdrs = ["mock_csr.h"],
    defines = ["MOCK_CSR"],
    deps = [
        "//sw/device/lib/base",
        "//sw/device/silicon_creator/testing:mask_rom_test",
        "@googletest//:gtest",
    ],
)

cc_test(
    name = "mock_csr_test",
    srcs = ["mock_csr_test.cc"],
    deps = [
        ":mock_csr",
        "@googletest//:gtest_main",
    ],
)

cc_library(
    name = "mock_abs_mmio",
    testonly = True,
    hdrs = [
        "//sw/device/lib/base:abs_mmio_h",
        "mock_abs_mmio.h",
    ],
    defines = ["MOCK_ABS_MMIO"],
    deps = [
        "//sw/device/lib/base/testing",
        "//sw/device/silicon_creator/testing:mask_rom_test",
        "@googletest//:gtest",
    ],
)

cc_library(
    name = "sec_mmio",
    srcs = ["sec_mmio.c"],
    hdrs = ["sec_mmio.h"],
    target_compatible_with = [OPENTITAN_CPU],
    deps = [
        "//sw/device/lib/base",
        "//sw/device/lib/base:abs_mmio",
        "//sw/device/silicon_creator/lib:error",
    ],
)

cc_library(
    name = "mock_sec_mmio",
    testonly = True,
    hdrs = [
        "mock_sec_mmio.h",
        "sec_mmio.h",
    ],
    deps = [
        "//sw/device/lib/base/testing",
        "//sw/device/silicon_creator/testing:mask_rom_test",
        "@googletest//:gtest",
    ],
)

cc_test(
    name = "sec_mmio_unittest",
    srcs = [
        "sec_mmio.h",
        "sec_mmio.c",
        "sec_mmio_unittest.cc",
    ],
    defines = ["OT_OFF_TARGET_TEST"],
    deps = [
        ":mock_abs_mmio",
        "//sw/device/lib/base",
        "//sw/device/silicon_creator/lib:error",
        "@googletest//:gtest_main",
    ],
)
