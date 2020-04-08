//===-- CAHP.td - Describe the CAHP Target Machine -------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// Copied from RISCV.td and modified.
//===----------------------------------------------------------------------===//

include "llvm/Target/Target.td"
//===----------------------------------------------------------------------===//
// Named operands for CSR instructions.
//===----------------------------------------------------------------------===//

include "CAHPSystemOperands.td"

//===----------------------------------------------------------------------===//
// Registers, calling conventions, instruction descriptions.
//===----------------------------------------------------------------------===//

include "CAHPSchedule.td"
include "CAHPRegisterInfo.td"
include "CAHPCallingConv.td"
include "CAHPInstrInfo.td"
include "CAHPRegisterBanks.td"
include "CAHPSchedRocket32.td"
include "CAHPSchedRocket64.td"

//===----------------------------------------------------------------------===//
// RISC-V processors supported.
//===----------------------------------------------------------------------===//

def : ProcessorModel<"generic-rv32", NoSchedModel, [FeatureRVCHints]>;

//===----------------------------------------------------------------------===//
// Define the RISC-V target.
//===----------------------------------------------------------------------===//

def CAHPInstrInfo : InstrInfo {
  let guessInstructionProperties = 0;
}

def CAHPAsmParser : AsmParser {
  let ShouldEmitMatchRegisterAltName = 1;
  let AllowDuplicateRegisterNames = 1;
}

def CAHPAsmWriter : AsmWriter {
  int PassSubtarget = 1;
}

def CAHP : Target {
  let InstructionSet = CAHPInstrInfo;
  let AssemblyParsers = [CAHPAsmParser];
  let AssemblyWriters = [CAHPAsmWriter];
  let AllowRegisterRenaming = 1;
}
