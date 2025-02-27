/* Copyright lowRISC contributors. */
/* Licensed under the Apache License, Version 2.0, see LICENSE for details. */
/* SPDX-License-Identifier: Apache-2.0 */

/**
 * Linker script for an OpenTitan flash (test) binaries.
 *
 * Portions of this file are Ibex-specific.
 */

OUTPUT_ARCH(riscv)
GROUP(-lgcc)

/**
 * Indicate that there are no dynamic libraries, whatsoever.
 */
__DYNAMIC = 0;

/**
 * Memory definitions are auto-generated.
 */
INCLUDE hw/top_earlgrey/sw/autogen/top_earlgrey_memory.ld

/**
/* Reserving space at the top of the RAM for the stack.
 * It is zeroed out so a size must be provided.
 */
_stack_size = 0x2000;
_stack_end = ORIGIN(ram_main) + LENGTH(ram_main);
_stack_start = _stack_end - _stack_size;

/* DV Log offset (has to be different to other boot stages). */
_dv_log_offset = 0x10000;

/**
 * The entry point in `test_rom_ext_start.S` is called `_start`. This
 * information in the ELF file is not used - instead we use the information in
 * the `.flash_header` section to understand where to start execution of a flash
 * image. We need this declaration so LLD does not error.
 */
ENTRY(_start);

SECTIONS {
  /**
   * The flash header. This will eventually contain other stuff, like a
   * signature, but for now it's just the entry point at offset zero.
   */
  .flash_header ORIGIN(eflash_virtual) : ALIGN(4) {
    KEEP(*(.flash_header))
  } > eflash_virtual

  /**
   * C runtime (CRT) section, containing program initialization code.
   *
   * The flash header contains the address of the entry point, _start, which is
   * inside this section. We keep them together in the linked elf files too.
   */
  .crt : ALIGN(4) {
    KEEP(*(.crt))
  } > eflash_virtual

  /**
   * Ibex interrupt vectors. See 'test_rom_ext_start.S' for more information.
   */
  .vectors : {
    *(.vectors)
  } > eflash_virtual

  /**
   * For LLVM profiling. This contains a pointer to the runtime initialization
   * function that is generated by the compiler. See
   * 'InstrProfiling::emitInitialization()' in 'InstrProfiling.cpp' and
   * 'getInstrProfInitFuncName()' in 'InstrProf.h'.
   */
  .init_array : ALIGN(4) {
      _init_array_start = .;
      *(.init_array)
      *(.init_array.*)
      . = ALIGN(4);
      _init_array_end = .;
  } > eflash_virtual

  /**
   * Standard text section, containing program code.
   */
  .text : ALIGN(4) {
    *(.text)
    *(.text.*)
  } > eflash_virtual

  /**
   * Read-only data section, containing all large compile-time constants, like
   * strings.
   */
  .rodata : ALIGN(4) {
    /* Small read-only data comes before regular read-only data for the same
     * reasons as in the data section */
    *(.srodata)
    *(.srodata.*)
    *(.rodata)
    *(.rodata.*)

    /* Read-only sections for LLVM profiling. */
    KEEP(*(__llvm_covfun))
    KEEP(*(__llvm_covmap))
    KEEP(*(__llvm_prf_names))
  } > eflash_virtual

  /**
   * "Intitial data" section, the initial values of the mutable data section
   * initialized at runtime.
   */
  .idata : ALIGN(4) {
    _data_init_start = .;
  } > eflash_virtual

  /**
   * Standard mutable data section, at the bottom of RAM. This will be
   * initialized from the .idata section at runtime by the CRT.
   */
  .data ORIGIN(ram_main): AT(_data_init_start) ALIGN(4) {
    _data_start = .;
    __global_pointer$ = . + 2048;

    /* Small data should come before larger data. This helps to ensure small
     * globals are within 2048 bytes of the value of `gp`, making their accesses
     * hopefully only take one instruction. */
    *(.sdata)
    *(.sdata.*)

    /* Other data will likely need multiple instructions to load, so we're less
     * concerned about address materialisation taking more than one instruction.
     */
    *(.data)
    *(.data.*)

    /* Sections for LLVM profiling. */
    KEEP(*(__llvm_prf_cnts))
    KEEP(*(__llvm_prf_data))

    . = ALIGN(4);
    _data_end = .;
  } > ram_main

  /**
   * Standard BSS section. This will be zeroed at runtime by the CRT.
   */
  .bss : ALIGN(4) {
    _bss_start = .;
    /* Small BSS comes before regular BSS for the same reasons as in the data
     * section. */
    *(.sbss)
    *(.sbss.*)
    *(.bss)
    *(.bss.*)
    . = ALIGN(4);
    _bss_end = .;
  } > ram_main

  /**
   * FreeRTOS heap (for OTTF).
   *
   * This is a separate NOLOAD section so that it does not end up in the `.bss`
   * section which gets zeroed during the second boot stage initialization,
   * causing wasted simulation cycles.
   */
  .freertos.heap (NOLOAD): ALIGN(4) {
    _freertos_heap_start = .;
    *(.freertos.heap)
  } > ram_main

  INCLUDE sw/device/info_sections.ld
}
