//===-- SPUMCAsmInfo.h - Cell SPU asm properties ---------------*- C++ -*--===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file contains the declaration of the SPUMCAsmInfo class.
//
//===----------------------------------------------------------------------===//

#ifndef SPUTARGETASMINFO_H
#define SPUTARGETASMINFO_H

#include "llvm/MC/MCAsmInfo.h"

namespace llvm {
  class Target;
  class StringRef;
  
  struct SPULinuxMCAsmInfo : public MCAsmInfo {
    explicit SPULinuxMCAsmInfo(const Target &T, const StringRef &TT);
  };
} // namespace llvm

#endif /* SPUTARGETASMINFO_H */
