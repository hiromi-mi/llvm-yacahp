//===-- CAHPTargetMachine.cpp - Define TargetMachine for CAHP -----------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Implements the info about CAHP target spec.
//
//===----------------------------------------------------------------------===//

#include "CAHPTargetMachine.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/CodeGen/Passes.h"
#include "llvm/CodeGen/TargetLoweringObjectFileImpl.h"
#include "llvm/CodeGen/TargetPassConfig.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/Support/FormattedStream.h"
#include "llvm/Support/TargetRegistry.h"
#include "llvm/Target/TargetOptions.h"


#include "TargetInfo/CAHPTargetInfo.h"

using namespace llvm;

extern "C" LLVM_EXTERNAL_VISIBILITY void LLVMInitializeCAHPTarget() {
  RegisterTargetMachine<CAHPTargetMachine> X(getTheCAHPTarget());
}

static StringRef computeDataLayout(const Triple &TT) {
   // e: little endian
   // m:e :  ELF mangling mode
   // p:32:32 : 32-bit pointer & 32-bit aligned
   // i64:64 : 64bit integers -> 64-bit aligned
   // n32: native integer -> 32-bit
   // S128 : stack alignment -> 128bits
  return "e-m:e-p:32:32-i64:64-n32-S128";
}

static Reloc::Model getEffectiveRelocModel(const Triple &TT,
                                           Optional<Reloc::Model> RM) {
  if (!RM.hasValue())
    return Reloc::Static;
  return *RM;
}

CAHPTargetMachine::CAHPTargetMachine(const Target &T, const Triple &TT,
                                       StringRef CPU, StringRef FS,
                                       const TargetOptions &Options,
                                       Optional<Reloc::Model> RM,
                                       Optional<CodeModel::Model> CM,
                                       CodeGenOpt::Level OL, bool JIT)
    : LLVMTargetMachine(T, computeDataLayout(TT), TT, CPU, FS, Options,
                        getEffectiveRelocModel(TT, RM),
                        getEffectiveCodeModel(CM, CodeModel::Small), OL),
      TLOF(std::make_unique<TargetLoweringObjectFileELF>()) {
  initAsmInfo();
}

TargetPassConfig *CAHPTargetMachine::createPassConfig(PassManagerBase &PM) {
  return new TargetPassConfig(*this, PM);
}
