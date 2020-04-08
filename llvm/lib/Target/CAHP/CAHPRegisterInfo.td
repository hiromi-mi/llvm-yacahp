//===-- CAHPRegisterInfo.td - RISC-V Register defs --------*- tablegen -*-===//
//
// Copied from ../RISCV/RISCVRegisterInfo.td and modified.
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
//  Declarations that describe the RISC-V register files
//===----------------------------------------------------------------------===//

let Namespace = "CAHP" in {
class CAHPReg<bits<5> Enc, string n, list<string> alt = []> : Register<n> {
  let HWEncoding{4-0} = Enc;
  let AltNames = alt;
}

def ABIRegAltName : RegAltNameIndex;
} // Namespace = "CAHP"

// Integer registers
// CostPerUse is set higher for registers that may not be compressible as they
// are not part of GPRC, the most restrictive register class used by the
// compressed instruction set. This will influence the greedy register
// allocator to reduce the use of registers that can't be encoded in 16 bit
// instructions. This affects register allocation even when compressed
// instruction isn't targeted, we see no major negative codegen impact.

let RegAltNameIndices = [ABIRegAltName] in {
  def X0  : CAHPReg<0, "x0", ["zero"]>, DwarfRegNum<[0]>;
  let CostPerUse = 1 in {
  def X1  : CAHPReg<1, "x1", ["ra"]>, DwarfRegNum<[1]>;
  def X2  : CAHPReg<2, "x2", ["sp"]>, DwarfRegNum<[2]>;
  def X3  : CAHPReg<3, "x3", ["gp"]>, DwarfRegNum<[3]>;
  def X4  : CAHPReg<4, "x4", ["tp"]>, DwarfRegNum<[4]>;
  def X5  : CAHPReg<5, "x5", ["t0"]>, DwarfRegNum<[5]>;
  def X6  : CAHPReg<6, "x6", ["t1"]>, DwarfRegNum<[6]>;
  def X7  : CAHPReg<7, "x7", ["t2"]>, DwarfRegNum<[7]>;
  }
  def X8  : CAHPReg<8, "x8", ["s0", "fp"]>, DwarfRegNum<[8]>;
  def X9  : CAHPReg<9, "x9", ["s1"]>, DwarfRegNum<[9]>;
  def X10 : CAHPReg<10,"x10", ["a0"]>, DwarfRegNum<[10]>;
  def X11 : CAHPReg<11,"x11", ["a1"]>, DwarfRegNum<[11]>;
  def X12 : CAHPReg<12,"x12", ["a2"]>, DwarfRegNum<[12]>;
  def X13 : CAHPReg<13,"x13", ["a3"]>, DwarfRegNum<[13]>;
  def X14 : CAHPReg<14,"x14", ["a4"]>, DwarfRegNum<[14]>;
  def X15 : CAHPReg<15,"x15", ["a5"]>, DwarfRegNum<[15]>;
}

def XLenVT : ValueTypeByHwMode<[RV32, RV64, DefaultMode],
                               [i32,  i64,  i32]>;

// The order of registers represents the preferred allocation sequence.
// Registers are listed in the order caller-save, callee-save, specials.
def GPR : RegisterClass<"CAHP", [XLenVT], 32, (add
    (sequence "X%u", 10, 17),
    (sequence "X%u", 0, 7),
  )> {
  let RegInfos = RegInfoByHwMode<
      [RV32,              RV64,              DefaultMode],
      [RegInfo<32,32,32>, RegInfo<64,64,64>, RegInfo<32,32,32>]>;
}

def GPRX0 : RegisterClass<"CAHP", [XLenVT], 32, (add X0)> {
  let RegInfos = RegInfoByHwMode<
      [RV32,              RV64,              DefaultMode],
      [RegInfo<32,32,32>, RegInfo<64,64,64>, RegInfo<32,32,32>]>;
}

// The order of registers represents the preferred allocation sequence.
// Registers are listed in the order caller-save, callee-save, specials.
def GPRNoX0 : RegisterClass<"CAHP", [XLenVT], 32, (add
    (sequence "X%u", 10, 17),
    (sequence "X%u", 5, 7),
    (sequence "X%u", 28, 31),
    (sequence "X%u", 8, 9),
    (sequence "X%u", 18, 27),
    (sequence "X%u", 1, 4)
  )> {
  let RegInfos = RegInfoByHwMode<
      [RV32,              RV64,              DefaultMode],
      [RegInfo<32,32,32>, RegInfo<64,64,64>, RegInfo<32,32,32>]>;
}

def GPRNoX0X2 : RegisterClass<"CAHP", [XLenVT], 32, (add
    (sequence "X%u", 10, 17),
    (sequence "X%u", 5, 7),
    (sequence "X%u", 28, 31),
    (sequence "X%u", 8, 9),
    (sequence "X%u", 18, 27),
    X1, X3, X4
  )> {
  let RegInfos = RegInfoByHwMode<
      [RV32,              RV64,              DefaultMode],
      [RegInfo<32,32,32>, RegInfo<64,64,64>, RegInfo<32,32,32>]>;
}

def GPRC : RegisterClass<"CAHP", [XLenVT], 32, (add
    (sequence "X%u", 10, 15),
    (sequence "X%u", 8, 9)
  )> {
  let RegInfos = RegInfoByHwMode<
      [RV32,              RV64,              DefaultMode],
      [RegInfo<32,32,32>, RegInfo<64,64,64>, RegInfo<32,32,32>]>;
}

// For indirect tail calls, we can't use callee-saved registers, as they are
// restored to the saved value before the tail call, which would clobber a call
// address.
def GPRTC : RegisterClass<"CAHP", [XLenVT], 32, (add
    (sequence "X%u", 5, 7),
    (sequence "X%u", 10, 17),
    (sequence "X%u", 28, 31)
  )> {
  let RegInfos = RegInfoByHwMode<
      [RV32,              RV64,              DefaultMode],
      [RegInfo<32,32,32>, RegInfo<64,64,64>, RegInfo<32,32,32>]>;
}

def SP : RegisterClass<"CAHP", [XLenVT], 32, (add X2)> {
  let RegInfos = RegInfoByHwMode<
      [RV32,              RV64,              DefaultMode],
      [RegInfo<32,32,32>, RegInfo<64,64,64>, RegInfo<32,32,32>]>;
}

// Floating point registers
let RegAltNameIndices = [ABIRegAltName] in {
  def F0_F  : CAHPReg32<0, "f0", ["ft0"]>, DwarfRegNum<[32]>;
  def F1_F  : CAHPReg32<1, "f1", ["ft1"]>, DwarfRegNum<[33]>;
  def F2_F  : CAHPReg32<2, "f2", ["ft2"]>, DwarfRegNum<[34]>;
  def F3_F  : CAHPReg32<3, "f3", ["ft3"]>, DwarfRegNum<[35]>;
  def F4_F  : CAHPReg32<4, "f4", ["ft4"]>, DwarfRegNum<[36]>;
  def F5_F  : CAHPReg32<5, "f5", ["ft5"]>, DwarfRegNum<[37]>;
  def F6_F  : CAHPReg32<6, "f6", ["ft6"]>, DwarfRegNum<[38]>;
  def F7_F  : CAHPReg32<7, "f7", ["ft7"]>, DwarfRegNum<[39]>;
  def F8_F  : CAHPReg32<8, "f8", ["fs0"]>, DwarfRegNum<[40]>;
  def F9_F  : CAHPReg32<9, "f9", ["fs1"]>, DwarfRegNum<[41]>;
  def F10_F : CAHPReg32<10,"f10", ["fa0"]>, DwarfRegNum<[42]>;
  def F11_F : CAHPReg32<11,"f11", ["fa1"]>, DwarfRegNum<[43]>;
  def F12_F : CAHPReg32<12,"f12", ["fa2"]>, DwarfRegNum<[44]>;
  def F13_F : CAHPReg32<13,"f13", ["fa3"]>, DwarfRegNum<[45]>;
  def F14_F : CAHPReg32<14,"f14", ["fa4"]>, DwarfRegNum<[46]>;
  def F15_F : CAHPReg32<15,"f15", ["fa5"]>, DwarfRegNum<[47]>;
  def F16_F : CAHPReg32<16,"f16", ["fa6"]>, DwarfRegNum<[48]>;
  def F17_F : CAHPReg32<17,"f17", ["fa7"]>, DwarfRegNum<[49]>;
  def F18_F : CAHPReg32<18,"f18", ["fs2"]>, DwarfRegNum<[50]>;
  def F19_F : CAHPReg32<19,"f19", ["fs3"]>, DwarfRegNum<[51]>;
  def F20_F : CAHPReg32<20,"f20", ["fs4"]>, DwarfRegNum<[52]>;
  def F21_F : CAHPReg32<21,"f21", ["fs5"]>, DwarfRegNum<[53]>;
  def F22_F : CAHPReg32<22,"f22", ["fs6"]>, DwarfRegNum<[54]>;
  def F23_F : CAHPReg32<23,"f23", ["fs7"]>, DwarfRegNum<[55]>;
  def F24_F : CAHPReg32<24,"f24", ["fs8"]>, DwarfRegNum<[56]>;
  def F25_F : CAHPReg32<25,"f25", ["fs9"]>, DwarfRegNum<[57]>;
  def F26_F : CAHPReg32<26,"f26", ["fs10"]>, DwarfRegNum<[58]>;
  def F27_F : CAHPReg32<27,"f27", ["fs11"]>, DwarfRegNum<[59]>;
  def F28_F : CAHPReg32<28,"f28", ["ft8"]>, DwarfRegNum<[60]>;
  def F29_F : CAHPReg32<29,"f29", ["ft9"]>, DwarfRegNum<[61]>;
  def F30_F : CAHPReg32<30,"f30", ["ft10"]>, DwarfRegNum<[62]>;
  def F31_F : CAHPReg32<31,"f31", ["ft11"]>, DwarfRegNum<[63]>;

  foreach Index = 0-31 in {
    def F#Index#_D : CAHPReg64<!cast<CAHPReg32>("F"#Index#"_F")>,
      DwarfRegNum<[!add(Index, 32)]>;
  }
}

// The order of registers represents the preferred allocation sequence,
// meaning caller-save regs are listed before callee-save.
def FPR32 : RegisterClass<"CAHP", [f32], 32, (add
    (sequence "F%u_F", 0, 7),
    (sequence "F%u_F", 10, 17),
    (sequence "F%u_F", 28, 31),
    (sequence "F%u_F", 8, 9),
    (sequence "F%u_F", 18, 27)
)>;

def FPR32C : RegisterClass<"CAHP", [f32], 32, (add
  (sequence "F%u_F", 10, 15),
  (sequence "F%u_F", 8, 9)
)>;

// The order of registers represents the preferred allocation sequence,
// meaning caller-save regs are listed before callee-save.
def FPR64 : RegisterClass<"CAHP", [f64], 64, (add
    (sequence "F%u_D", 0, 7),
    (sequence "F%u_D", 10, 17),
    (sequence "F%u_D", 28, 31),
    (sequence "F%u_D", 8, 9),
    (sequence "F%u_D", 18, 27)
)>;

def FPR64C : RegisterClass<"CAHP", [f64], 64, (add
  (sequence "F%u_D", 10, 15),
  (sequence "F%u_D", 8, 9)
)>;
