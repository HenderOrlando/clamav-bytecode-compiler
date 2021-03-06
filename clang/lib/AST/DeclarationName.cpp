//===-- DeclarationName.cpp - Declaration names implementation --*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file implements the DeclarationName and DeclarationNameTable
// classes.
//
//===----------------------------------------------------------------------===//
#include "clang/AST/DeclarationName.h"
#include "clang/AST/Type.h"
#include "clang/AST/TypeOrdering.h"
#include "clang/AST/Decl.h"
#include "clang/Basic/IdentifierTable.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/FoldingSet.h"
#include <cstdio>
using namespace clang;

namespace clang {
/// CXXSpecialName - Records the type associated with one of the
/// "special" kinds of declaration names in C++, e.g., constructors,
/// destructors, and conversion functions.
class CXXSpecialName
  : public DeclarationNameExtra, public llvm::FoldingSetNode {
public:
  /// Type - The type associated with this declaration name.
  QualType Type;

  /// FETokenInfo - Extra information associated with this declaration
  /// name that can be used by the front end.
  void *FETokenInfo;

  void Profile(llvm::FoldingSetNodeID &ID) {
    ID.AddInteger(ExtraKindOrNumArgs);
    ID.AddPointer(Type.getAsOpaquePtr());
  }
};

/// CXXOperatorIdName - Contains extra information for the name of an
/// overloaded operator in C++, such as "operator+.
class CXXOperatorIdName : public DeclarationNameExtra {
public:
  /// FETokenInfo - Extra information associated with this operator
  /// name that can be used by the front end.
  void *FETokenInfo;
};

/// CXXLiberalOperatorName - Contains the actual identifier that makes up the
/// name.
///
/// This identifier is stored here rather than directly in DeclarationName so as
/// to allow Objective-C selectors, which are about a million times more common,
/// to consume minimal memory.
class CXXLiteralOperatorIdName
  : public DeclarationNameExtra, public llvm::FoldingSetNode {
public:
  IdentifierInfo *ID;

  void Profile(llvm::FoldingSetNodeID &FSID) {
    FSID.AddPointer(ID);
  }
};

static int compareInt(unsigned A, unsigned B) {
  return (A < B ? -1 : (A > B ? 1 : 0));
}

int DeclarationName::compare(DeclarationName LHS, DeclarationName RHS) {
  if (LHS.getNameKind() != RHS.getNameKind())
    return (LHS.getNameKind() < RHS.getNameKind() ? -1 : 1);
  
  switch (LHS.getNameKind()) {
  case DeclarationName::Identifier: {
    IdentifierInfo *LII = LHS.getAsIdentifierInfo();
    IdentifierInfo *RII = RHS.getAsIdentifierInfo();
    if (!LII) return RII ? -1 : 0;
    if (!RII) return 1;
    
    return LII->getName().compare(RII->getName());
  }

  case DeclarationName::ObjCZeroArgSelector:
  case DeclarationName::ObjCOneArgSelector:
  case DeclarationName::ObjCMultiArgSelector: {
    Selector LHSSelector = LHS.getObjCSelector();
    Selector RHSSelector = RHS.getObjCSelector();
    unsigned LN = LHSSelector.getNumArgs(), RN = RHSSelector.getNumArgs();
    for (unsigned I = 0, N = std::min(LN, RN); I != N; ++I) {
      IdentifierInfo *LHSId = LHSSelector.getIdentifierInfoForSlot(I);
      IdentifierInfo *RHSId = RHSSelector.getIdentifierInfoForSlot(I);
        
      switch (LHSId->getName().compare(RHSId->getName())) {
      case -1: return true;
      case 1: return false;
      default: break;
      }
    }

    return compareInt(LN, RN);
  }
  
  case DeclarationName::CXXConstructorName:
  case DeclarationName::CXXDestructorName:
  case DeclarationName::CXXConversionFunctionName:
    if (QualTypeOrdering()(LHS.getCXXNameType(), RHS.getCXXNameType()))
      return -1;
    if (QualTypeOrdering()(RHS.getCXXNameType(), LHS.getCXXNameType()))
      return 1;
    return 0;
              
  case DeclarationName::CXXOperatorName:
    return compareInt(LHS.getCXXOverloadedOperator(),
                      RHS.getCXXOverloadedOperator());

  case DeclarationName::CXXLiteralOperatorName:
    return LHS.getCXXLiteralIdentifier()->getName().compare(
                                   RHS.getCXXLiteralIdentifier()->getName());
              
  case DeclarationName::CXXUsingDirective:
    return 0;
  }
              
  return 0;
}

} // end namespace clang

DeclarationName::DeclarationName(Selector Sel) {
  if (!Sel.getAsOpaquePtr()) {
    Ptr = 0;
    return;
  }

  switch (Sel.getNumArgs()) {
  case 0:
    Ptr = reinterpret_cast<uintptr_t>(Sel.getAsIdentifierInfo());
    assert((Ptr & PtrMask) == 0 && "Improperly aligned IdentifierInfo");
    Ptr |= StoredObjCZeroArgSelector;
    break;

  case 1:
    Ptr = reinterpret_cast<uintptr_t>(Sel.getAsIdentifierInfo());
    assert((Ptr & PtrMask) == 0 && "Improperly aligned IdentifierInfo");
    Ptr |= StoredObjCOneArgSelector;
    break;

  default:
    Ptr = Sel.InfoPtr & ~Selector::ArgFlags;
    assert((Ptr & PtrMask) == 0 && "Improperly aligned MultiKeywordSelector");
    Ptr |= StoredDeclarationNameExtra;
    break;
  }
}

DeclarationName::NameKind DeclarationName::getNameKind() const {
  switch (getStoredNameKind()) {
  case StoredIdentifier:          return Identifier;
  case StoredObjCZeroArgSelector: return ObjCZeroArgSelector;
  case StoredObjCOneArgSelector:  return ObjCOneArgSelector;

  case StoredDeclarationNameExtra:
    switch (getExtra()->ExtraKindOrNumArgs) {
    case DeclarationNameExtra::CXXConstructor:
      return CXXConstructorName;

    case DeclarationNameExtra::CXXDestructor:
      return CXXDestructorName;

    case DeclarationNameExtra::CXXConversionFunction:
      return CXXConversionFunctionName;

    case DeclarationNameExtra::CXXLiteralOperator:
      return CXXLiteralOperatorName;

    case DeclarationNameExtra::CXXUsingDirective:
      return CXXUsingDirective;

    default:
      // Check if we have one of the CXXOperator* enumeration values.
      if (getExtra()->ExtraKindOrNumArgs <
            DeclarationNameExtra::CXXUsingDirective)
        return CXXOperatorName;

      return ObjCMultiArgSelector;
    }
    break;
  }

  // Can't actually get here.
  assert(0 && "This should be unreachable!");
  return Identifier;
}

bool DeclarationName::isDependentName() const {
  QualType T = getCXXNameType();
  return !T.isNull() && T->isDependentType();
}

std::string DeclarationName::getAsString() const {
  switch (getNameKind()) {
  case Identifier:
    if (const IdentifierInfo *II = getAsIdentifierInfo())
      return II->getName();
    return "";

  case ObjCZeroArgSelector:
  case ObjCOneArgSelector:
  case ObjCMultiArgSelector:
    return getObjCSelector().getAsString();

  case CXXConstructorName: {
    QualType ClassType = getCXXNameType();
    if (const RecordType *ClassRec = ClassType->getAs<RecordType>())
      return ClassRec->getDecl()->getNameAsString();
    return ClassType.getAsString();
  }

  case CXXDestructorName: {
    std::string Result = "~";
    QualType Type = getCXXNameType();
    if (const RecordType *Rec = Type->getAs<RecordType>())
      Result += Rec->getDecl()->getNameAsString();
    else
      Result += Type.getAsString();
    return Result;
  }

  case CXXOperatorName: {
    static const char* const OperatorNames[NUM_OVERLOADED_OPERATORS] = {
      0,
#define OVERLOADED_OPERATOR(Name,Spelling,Token,Unary,Binary,MemberOnly) \
      Spelling,
#include "clang/Basic/OperatorKinds.def"
    };
    const char *OpName = OperatorNames[getCXXOverloadedOperator()];
    assert(OpName && "not an overloaded operator");

    std::string Result = "operator";
    if (OpName[0] >= 'a' && OpName[0] <= 'z')
      Result += ' ';
    Result += OpName;
    return Result;
  }

  case CXXLiteralOperatorName: {
    return "operator \"\" " + std::string(getCXXLiteralIdentifier()->getName());
  }

  case CXXConversionFunctionName: {
    std::string Result = "operator ";
    QualType Type = getCXXNameType();
    if (const RecordType *Rec = Type->getAs<RecordType>())
      Result += Rec->getDecl()->getNameAsString();
    else
      Result += Type.getAsString();
    return Result;
  }
  case CXXUsingDirective:
    return "<using-directive>";
  }

  assert(false && "Unexpected declaration name kind");
  return "";
}

QualType DeclarationName::getCXXNameType() const {
  if (CXXSpecialName *CXXName = getAsCXXSpecialName())
    return CXXName->Type;
  else
    return QualType();
}

OverloadedOperatorKind DeclarationName::getCXXOverloadedOperator() const {
  if (CXXOperatorIdName *CXXOp = getAsCXXOperatorIdName()) {
    unsigned value
      = CXXOp->ExtraKindOrNumArgs - DeclarationNameExtra::CXXConversionFunction;
    return static_cast<OverloadedOperatorKind>(value);
  } else {
    return OO_None;
  }
}

IdentifierInfo *DeclarationName::getCXXLiteralIdentifier() const {
  if (CXXLiteralOperatorIdName *CXXLit = getAsCXXLiteralOperatorIdName())
    return CXXLit->ID;
  else
    return 0;
}

Selector DeclarationName::getObjCSelector() const {
  switch (getNameKind()) {
  case ObjCZeroArgSelector:
    return Selector(reinterpret_cast<IdentifierInfo *>(Ptr & ~PtrMask), 0);

  case ObjCOneArgSelector:
    return Selector(reinterpret_cast<IdentifierInfo *>(Ptr & ~PtrMask), 1);

  case ObjCMultiArgSelector:
    return Selector(reinterpret_cast<MultiKeywordSelector *>(Ptr & ~PtrMask));

  default:
    break;
  }

  return Selector();
}

void *DeclarationName::getFETokenInfoAsVoid() const {
  switch (getNameKind()) {
  case Identifier:
    return getAsIdentifierInfo()->getFETokenInfo<void>();

  case CXXConstructorName:
  case CXXDestructorName:
  case CXXConversionFunctionName:
    return getAsCXXSpecialName()->FETokenInfo;

  case CXXOperatorName:
    return getAsCXXOperatorIdName()->FETokenInfo;

  case CXXLiteralOperatorName:
    return getCXXLiteralIdentifier()->getFETokenInfo<void>();

  default:
    assert(false && "Declaration name has no FETokenInfo");
  }
  return 0;
}

void DeclarationName::setFETokenInfo(void *T) {
  switch (getNameKind()) {
  case Identifier:
    getAsIdentifierInfo()->setFETokenInfo(T);
    break;

  case CXXConstructorName:
  case CXXDestructorName:
  case CXXConversionFunctionName:
    getAsCXXSpecialName()->FETokenInfo = T;
    break;

  case CXXOperatorName:
    getAsCXXOperatorIdName()->FETokenInfo = T;
    break;

  case CXXLiteralOperatorName:
    getCXXLiteralIdentifier()->setFETokenInfo(T);
    break;

  default:
    assert(false && "Declaration name has no FETokenInfo");
  }
}

DeclarationName DeclarationName::getUsingDirectiveName() {
  // Single instance of DeclarationNameExtra for using-directive
  static const DeclarationNameExtra UDirExtra =
    { DeclarationNameExtra::CXXUsingDirective };

  uintptr_t Ptr = reinterpret_cast<uintptr_t>(&UDirExtra);
  Ptr |= StoredDeclarationNameExtra;

  return DeclarationName(Ptr);
}

void DeclarationName::dump() const {
  fprintf(stderr, "%s\n", getAsString().c_str());
}

DeclarationNameTable::DeclarationNameTable() {
  CXXSpecialNamesImpl = new llvm::FoldingSet<CXXSpecialName>;
  CXXLiteralOperatorNames = new llvm::FoldingSet<CXXLiteralOperatorIdName>;

  // Initialize the overloaded operator names.
  CXXOperatorNames = new CXXOperatorIdName[NUM_OVERLOADED_OPERATORS];
  for (unsigned Op = 0; Op < NUM_OVERLOADED_OPERATORS; ++Op) {
    CXXOperatorNames[Op].ExtraKindOrNumArgs
      = Op + DeclarationNameExtra::CXXConversionFunction;
    CXXOperatorNames[Op].FETokenInfo = 0;
  }
}

DeclarationNameTable::~DeclarationNameTable() {
  llvm::FoldingSet<CXXSpecialName> *SpecialNames =
    static_cast<llvm::FoldingSet<CXXSpecialName>*>(CXXSpecialNamesImpl);
  llvm::FoldingSetIterator<CXXSpecialName>
                           SI = SpecialNames->begin(), SE = SpecialNames->end();

  while (SI != SE) {
    CXXSpecialName *n = &*SI++;
    delete n;
  }


  llvm::FoldingSet<CXXLiteralOperatorIdName> *LiteralNames
    = static_cast<llvm::FoldingSet<CXXLiteralOperatorIdName>*>
                                                      (CXXLiteralOperatorNames);
  llvm::FoldingSetIterator<CXXLiteralOperatorIdName>
                           LI = LiteralNames->begin(), LE = LiteralNames->end();

  while (LI != LE) {
    CXXLiteralOperatorIdName *n = &*LI++;
    delete n;
  }

  delete SpecialNames;
  delete LiteralNames;
  delete [] CXXOperatorNames;
}

DeclarationName
DeclarationNameTable::getCXXSpecialName(DeclarationName::NameKind Kind,
                                        CanQualType Ty) {
  assert(Kind >= DeclarationName::CXXConstructorName &&
         Kind <= DeclarationName::CXXConversionFunctionName &&
         "Kind must be a C++ special name kind");
  llvm::FoldingSet<CXXSpecialName> *SpecialNames
    = static_cast<llvm::FoldingSet<CXXSpecialName>*>(CXXSpecialNamesImpl);

  DeclarationNameExtra::ExtraKind EKind;
  switch (Kind) {
  case DeclarationName::CXXConstructorName:
    EKind = DeclarationNameExtra::CXXConstructor;
    assert(!Ty.hasQualifiers() &&"Constructor type must be unqualified");
    break;
  case DeclarationName::CXXDestructorName:
    EKind = DeclarationNameExtra::CXXDestructor;
    assert(!Ty.hasQualifiers() && "Destructor type must be unqualified");
    break;
  case DeclarationName::CXXConversionFunctionName:
    EKind = DeclarationNameExtra::CXXConversionFunction;
    break;
  default:
    return DeclarationName();
  }

  // Unique selector, to guarantee there is one per name.
  llvm::FoldingSetNodeID ID;
  ID.AddInteger(EKind);
  ID.AddPointer(Ty.getAsOpaquePtr());

  void *InsertPos = 0;
  if (CXXSpecialName *Name = SpecialNames->FindNodeOrInsertPos(ID, InsertPos))
    return DeclarationName(Name);

  CXXSpecialName *SpecialName = new CXXSpecialName;
  SpecialName->ExtraKindOrNumArgs = EKind;
  SpecialName->Type = Ty;
  SpecialName->FETokenInfo = 0;

  SpecialNames->InsertNode(SpecialName, InsertPos);
  return DeclarationName(SpecialName);
}

DeclarationName
DeclarationNameTable::getCXXOperatorName(OverloadedOperatorKind Op) {
  return DeclarationName(&CXXOperatorNames[(unsigned)Op]);
}

DeclarationName
DeclarationNameTable::getCXXLiteralOperatorName(IdentifierInfo *II) {
  llvm::FoldingSet<CXXLiteralOperatorIdName> *LiteralNames
    = static_cast<llvm::FoldingSet<CXXLiteralOperatorIdName>*>
                                                      (CXXLiteralOperatorNames);

  llvm::FoldingSetNodeID ID;
  ID.AddPointer(II);

  void *InsertPos = 0;
  if (CXXLiteralOperatorIdName *Name =
                               LiteralNames->FindNodeOrInsertPos(ID, InsertPos))
    return DeclarationName (Name);
  
  CXXLiteralOperatorIdName *LiteralName = new CXXLiteralOperatorIdName;
  LiteralName->ExtraKindOrNumArgs = DeclarationNameExtra::CXXLiteralOperator;
  LiteralName->ID = II;

  LiteralNames->InsertNode(LiteralName, InsertPos);
  return DeclarationName(LiteralName);
}

unsigned
llvm::DenseMapInfo<clang::DeclarationName>::
getHashValue(clang::DeclarationName N) {
  return DenseMapInfo<void*>::getHashValue(N.getAsOpaquePtr());
}

