//===-- CAHPTargetInfo.cpp - CAHP Target Implementation -----------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "TargetInfo/CAHPTargetInfo.h"
#include "llvm/Support/TargetRegistry.h"
using namespace llvm;

Target &llvm::getTheCAHPTarget() {
  static Target TheCAHPTarget;
  return TheCAHPTarget;
}

extern "C" LLVM_EXTERNAL_VISIBILITY void LLVMInitializeCAHPTargetInfo() {
  RegisterTarget<Triple::cahp> X(getTheCAHPTarget(), "cahp",
                                    "CAHP", "CAHP");
}

// https://github.com/lowRISC/riscv-llvm/blob/master/0004-RISCV-Add-stub-backend.patch
// FIXME: Temporary stub - this function must be defined for linking
// to succeed and will be called unconditionally by llc, so must be a no-op.
// Remove once this function is properly implemented.
extern "C" void LLVMInitializeCAHPTargetMC() {}
