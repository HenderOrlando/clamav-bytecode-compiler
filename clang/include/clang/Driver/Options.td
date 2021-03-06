//===--- DriverOptions.td - Options for clang -----------------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
//  This file defines the options accepted by clang.
//
//===----------------------------------------------------------------------===//

// Include the common option parsing interfaces.
include "OptParser.td"

/////////
// Groups

// Meta-group which defines
def CompileOnly_Group     : OptionGroup<"<CompileOnly group>">;

def I_Group               : OptionGroup<"<I group>">, Group<CompileOnly_Group>;
def M_Group               : OptionGroup<"<M group>">, Group<CompileOnly_Group>;
def T_Group               : OptionGroup<"<T group>">;
def O_Group               : OptionGroup<"<O group>">, Group<CompileOnly_Group>;
def W_Group               : OptionGroup<"<W group>">, Group<CompileOnly_Group>;
def X_Group               : OptionGroup<"<X group>">;
def a_Group               : OptionGroup<"<a group>">;
def d_Group               : OptionGroup<"<d group>">;
def f_Group               : OptionGroup<"<f group>">, Group<CompileOnly_Group>;
def g_Group               : OptionGroup<"<g group>">;
def i_Group               : OptionGroup<"<i group>">, Group<CompileOnly_Group>;
def clang_i_Group         : OptionGroup<"<clang i group>">, Group<i_Group>;
def m_Group               : OptionGroup<"<m group>">, Group<CompileOnly_Group>;
def m_x86_Features_Group  : OptionGroup<"<m x86 features group>">, Group<m_Group>;
def u_Group               : OptionGroup<"<u group>">;

def pedantic_Group        : OptionGroup<"<pedantic group>">,
  Group<CompileOnly_Group>;

// Temporary groups for clang options which we know we don't support,
// but don't want to verbosely warn the user about.
def clang_ignored_f_Group : OptionGroup<"<clang ignored f group>">,
  Group<f_Group>;
def clang_ignored_m_Group : OptionGroup<"<clang ignored m group>">,
  Group<m_Group>;

/////////
// Options

// The internal option ID must be a valid C++ identifier and results in a
// clang::driver::options::OPT_XX enum constant for XX.
//
// We want to unambiguously be able to refer to options from the driver source
// code, for this reason the option name is mangled into an ID. This mangling
// isn't guaranteed to have an inverse, but for practical purposes it does.
//
// The mangling scheme is to ignore the leading '-', and perform the following
// substitutions:
//   _ => __
//   - => _
//   # => _HASH
//   , => _COMMA
//   = => _EQ
//   C++ => CXX
//   . => _

// Developer Driver Options

def ccc_Group : OptionGroup<"<clang internal options>">;
def ccc_driver_Group : OptionGroup<"<clang driver internal options>">,
  Group<ccc_Group>, HelpText<"DRIVER OPTIONS">;
def ccc_debug_Group : OptionGroup<"<clang debug/development internal options>">,
  Group<ccc_Group>, HelpText<"DEBUG/DEVELOPMENT OPTIONS">;

class CCCDriverOpt : Group<ccc_driver_Group>, Flags<[DriverOption, HelpHidden]>;
def ccc_cxx : Flag<"-ccc-cxx">, CCCDriverOpt,
  HelpText<"Act as a C++ driver">;
def ccc_echo : Flag<"-ccc-echo">, CCCDriverOpt,
  HelpText<"Echo commands before running them">;
def ccc_gcc_name : Separate<"-ccc-gcc-name">, CCCDriverOpt,
  HelpText<"Name for native GCC compiler">,
  MetaVarName<"<gcc-path>">;
def ccc_clang_cxx : Flag<"-ccc-clang-cxx">, CCCDriverOpt,
  HelpText<"Enable the clang compiler for C++">;
def ccc_no_clang_cxx : Flag<"-ccc-no-clang-cxx">, CCCDriverOpt,
  HelpText<"Disable the clang compiler for C++">;
def ccc_no_clang : Flag<"-ccc-no-clang">, CCCDriverOpt,
  HelpText<"Disable the clang compiler">;
def ccc_no_clang_cpp : Flag<"-ccc-no-clang-cpp">, CCCDriverOpt,
  HelpText<"Disable the clang preprocessor">;
def ccc_clang_archs : Separate<"-ccc-clang-archs">, CCCDriverOpt,
  HelpText<"Comma separate list of architectures to use the clang compiler for">,
  MetaVarName<"<arch-list>">;
def ccc_pch_is_pch : Flag<"-ccc-pch-is-pch">, CCCDriverOpt,
  HelpText<"Use lazy PCH for precompiled headers">;
def ccc_pch_is_pth : Flag<"-ccc-pch-is-pth">, CCCDriverOpt,
  HelpText<"Use pretokenized headers for precompiled headers">;

class CCCDebugOpt : Group<ccc_debug_Group>, Flags<[DriverOption, HelpHidden]>;
def ccc_host_triple : Separate<"-ccc-host-triple">, CCCDebugOpt,
  HelpText<"Simulate running on the given target">;
def ccc_install_dir : Separate<"-ccc-install-dir">, CCCDebugOpt,
  HelpText<"Simulate installation in the given directory">;
def ccc_print_options : Flag<"-ccc-print-options">, CCCDebugOpt,
  HelpText<"Dump parsed command line arguments">;
def ccc_print_phases : Flag<"-ccc-print-phases">, CCCDebugOpt,
  HelpText<"Dump list of actions to perform">;
def ccc_print_bindings : Flag<"-ccc-print-bindings">, CCCDebugOpt,
  HelpText<"Show bindings of tools to actions">;

// Make sure all other -ccc- options are rejected.
def ccc_ : Joined<"-ccc-">, Group<ccc_Group>, Flags<[Unsupported]>;

// Standard Options

def _HASH_HASH_HASH : Flag<"-###">, Flags<[DriverOption]>,
    HelpText<"Print the commands to run for this compilation">;
def A : JoinedOrSeparate<"-A">;
def B : JoinedOrSeparate<"-B">, Flags<[Unsupported]>;
def CC : Flag<"-CC">;
def C : Flag<"-C">;
def D : JoinedOrSeparate<"-D">, Group<CompileOnly_Group>;
def E : Flag<"-E">, Flags<[DriverOption]>,
  HelpText<"Only run the preprocessor">;
def F : JoinedOrSeparate<"-F">;
def H : Flag<"-H">;
def I_ : Flag<"-I-">, Group<I_Group>;
def I : JoinedOrSeparate<"-I">, Group<I_Group>;
def L : JoinedOrSeparate<"-L">;
def MD : Flag<"-MD">, Group<M_Group>;
def MF : JoinedOrSeparate<"-MF">, Group<M_Group>;
def MG : Flag<"-MG">, Group<M_Group>;
def MMD : Flag<"-MMD">, Group<M_Group>;
def MM : Flag<"-MM">, Group<M_Group>;
def MP : Flag<"-MP">, Group<M_Group>;
def MQ : JoinedOrSeparate<"-MQ">, Group<M_Group>;
def MT : JoinedOrSeparate<"-MT">, Group<M_Group>;
def Mach : Flag<"-Mach">;
def M : Flag<"-M">, Group<M_Group>;
def O4 : Joined<"-O4">, Group<O_Group>;
def ObjCXX : Flag<"-ObjC++">, Flags<[DriverOption]>,
  HelpText<"Treat source input files as Objective-C++ inputs">;
def ObjC : Flag<"-ObjC">, Flags<[DriverOption]>,
  HelpText<"Treat source input files as Objective-C inputs">;
def O : Joined<"-O">, Group<O_Group>;
def P : Flag<"-P">;
def Qn : Flag<"-Qn">;
def Qunused_arguments : Flag<"-Qunused-arguments">, Flags<[DriverOption]>,
  HelpText<"Don't emit warning for unused driver arguments">;
def Q : Flag<"-Q">;
def R : Flag<"-R">;
def S : Flag<"-S">, Flags<[DriverOption]>,
  HelpText<"Only run preprocess and compilation steps">;
def Tbss : JoinedOrSeparate<"-Tbss">, Group<T_Group>;
def Tdata : JoinedOrSeparate<"-Tdata">, Group<T_Group>;
def Ttext : JoinedOrSeparate<"-Ttext">, Group<T_Group>;
def T : JoinedOrSeparate<"-T">, Group<T_Group>;
def U : JoinedOrSeparate<"-U">, Group<CompileOnly_Group>;
def V : JoinedOrSeparate<"-V">, Flags<[DriverOption, Unsupported]>;
def Wa_COMMA : CommaJoined<"-Wa,">,
  HelpText<"Pass the comma separated arguments in <arg> to the assembler">,
  MetaVarName<"<arg>">;
def Wall : Flag<"-Wall">, Group<W_Group>;
def Wextra : Flag<"-Wextra">, Group<W_Group>;
def Wl_COMMA : CommaJoined<"-Wl,">, Flags<[LinkerInput, RenderAsInput]>,
  HelpText<"Pass the comma separated arguments in <arg> to the linker">,
  MetaVarName<"<arg>">;
def Wno_nonportable_cfstrings : Joined<"-Wno-nonportable-cfstrings">, Group<W_Group>;
def Wnonportable_cfstrings : Joined<"-Wnonportable-cfstrings">, Group<W_Group>;
def Wp_COMMA : CommaJoined<"-Wp,">,
  HelpText<"Pass the comma separated arguments in <arg> to the preprocessor">,
  MetaVarName<"<arg>">;
def W_Joined : Joined<"-W">, Group<W_Group>;
def Xanalyzer : Separate<"-Xanalyzer">,
  HelpText<"Pass <arg> to the static analyzer">, MetaVarName<"<arg>">;
def Xarch__ : JoinedAndSeparate<"-Xarch_">, Flags<[DriverOption]>;
def Xassembler : Separate<"-Xassembler">,
  HelpText<"Pass <arg> to the assembler">, MetaVarName<"<arg>">;
def Xclang : Separate<"-Xclang">,
  HelpText<"Pass <arg> to the clang compiler">, MetaVarName<"<arg>">;
def Xlinker : Separate<"-Xlinker">, Flags<[LinkerInput, RenderAsInput]>,
  HelpText<"Pass <arg> to the linker">, MetaVarName<"<arg>">;
def Xpreprocessor : Separate<"-Xpreprocessor">,
  HelpText<"Pass <arg> to the preprocessor">, MetaVarName<"<arg>">;
def X_Flag : Flag<"-X">;
def X_Joined : Joined<"-X">;
def Z_Flag : Flag<"-Z">;
def Z_Joined : Joined<"-Z">;
def all__load : Flag<"-all_load">;
def allowable__client : Separate<"-allowable_client">;
def ansi : Flag<"-ansi">, Group<a_Group>;
def arch__errors__fatal : Flag<"-arch_errors_fatal">;
def arch : Separate<"-arch">, Flags<[DriverOption]>;
def a : Joined<"-a">, Group<a_Group>;
def bind__at__load : Flag<"-bind_at_load">;
def bundle__loader : Separate<"-bundle_loader">;
def bundle : Flag<"-bundle">;
def b : JoinedOrSeparate<"-b">, Flags<[Unsupported]>;
def client__name : JoinedOrSeparate<"-client_name">;
def combine : Flag<"-combine">, Flags<[DriverOption, Unsupported]>;
def compatibility__version : JoinedOrSeparate<"-compatibility_version">;
def coverage : Flag<"-coverage">;
def cpp_precomp : Flag<"-cpp-precomp">;
def current__version : JoinedOrSeparate<"-current_version">;
def c : Flag<"-c">, Flags<[DriverOption]>,
  HelpText<"Only run preprocess, compile, and assemble steps">;
def dA : Flag<"-dA">, Group<d_Group>;
def dD : Flag<"-dD">, Group<d_Group>;
def dM : Flag<"-dM">, Group<d_Group>;
def dead__strip : Flag<"-dead_strip">;
def dependency_file : Separate<"-dependency-file">;
def dumpmachine : Flag<"-dumpmachine">, Flags<[Unsupported]>;
def dumpspecs : Flag<"-dumpspecs">, Flags<[Unsupported]>;
def dumpversion : Flag<"-dumpversion">;
def dylib__file : Separate<"-dylib_file">;
def dylinker__install__name : JoinedOrSeparate<"-dylinker_install_name">;
def dylinker : Flag<"-dylinker">;
def dynamiclib : Flag<"-dynamiclib">;
def dynamic : Flag<"-dynamic">, Flags<[NoArgumentUnused]>;
def d_Flag : Flag<"-d">, Group<d_Group>;
def d_Joined : Joined<"-d">, Group<d_Group>;
def emit_ast : Flag<"-emit-ast">,
  HelpText<"Emit Clang AST files for source inputs">;
def emit_llvm : Flag<"-emit-llvm">,
  HelpText<"Use the LLVM representation for assembler and object files">;
def exported__symbols__list : Separate<"-exported_symbols_list">;
def e : JoinedOrSeparate<"-e">;
def fPIC : Flag<"-fPIC">, Group<f_Group>;
def fPIE : Flag<"-fPIE">, Group<f_Group>;
def fapple_kext : Flag<"-fapple-kext">, Group<f_Group>;
def fasm_blocks : Flag<"-fasm-blocks">, Group<clang_ignored_f_Group>;
def fassume_sane_operator_new : Flag<"-fassume-sane-operator-new">, Group<f_Group>;
def fastcp : Flag<"-fastcp">, Group<f_Group>;
def fastf : Flag<"-fastf">, Group<f_Group>;
def fast : Flag<"-fast">, Group<f_Group>;
def fasynchronous_unwind_tables : Flag<"-fasynchronous-unwind-tables">, Group<f_Group>;
def fblocks : Flag<"-fblocks">, Group<f_Group>;
def fbootclasspath_EQ : Joined<"-fbootclasspath=">, Group<f_Group>;
def fbuiltin_strcat : Flag<"-fbuiltin-strcat">, Group<f_Group>;
def fbuiltin_strcpy : Flag<"-fbuiltin-strcpy">, Group<f_Group>;
def fbuiltin : Flag<"-fbuiltin">, Group<f_Group>;
def fcatch_undefined_behavior : Flag<"-fcatch-undefined-behavior">,
    Group<f_Group>, HelpText<"Generate runtime checks for undefined behavior.">;
def fclasspath_EQ : Joined<"-fclasspath=">, Group<f_Group>;
def fcolor_diagnostics : Flag<"-fcolor-diagnostics">, Group<f_Group>;
def fcommon : Flag<"-fcommon">, Group<f_Group>;
def fcompile_resource_EQ : Joined<"-fcompile-resource=">, Group<f_Group>;
def fconstant_cfstrings : Flag<"-fconstant-cfstrings">, Group<clang_ignored_f_Group>;
def fconstant_string_class_EQ : Joined<"-fconstant-string-class=">, Group<f_Group>;
def fcreate_profile : Flag<"-fcreate-profile">, Group<f_Group>;
def fdebug_pass_arguments : Flag<"-fdebug-pass-arguments">, Group<f_Group>;
def fdebug_pass_structure : Flag<"-fdebug-pass-structure">, Group<f_Group>;
def fdiagnostics_binary : Flag<"-fdiagnostics-binary">, Group<f_Group>, Flags<[HelpHidden]>;
def fdiagnostics_fixit_info : Flag<"-fdiagnostics-fixit-info">, Group<f_Group>;
def fdiagnostics_print_source_range_info : Flag<"-fdiagnostics-print-source-range-info">, Group<f_Group>;
def fdiagnostics_show_option : Flag<"-fdiagnostics-show-option">, Group<f_Group>;
def fdollars_in_identifiers : Flag<"-fdollars-in-identifiers">, Group<f_Group>;
def feliminate_unused_debug_symbols : Flag<"-feliminate-unused-debug-symbols">, Group<f_Group>;
def femit_all_decls : Flag<"-femit-all-decls">, Group<f_Group>;
def fencoding_EQ : Joined<"-fencoding=">, Group<f_Group>;
def fexceptions : Flag<"-fexceptions">, Group<f_Group>;
def fextdirs_EQ : Joined<"-fextdirs=">, Group<f_Group>;
def ffreestanding : Flag<"-ffreestanding">, Group<f_Group>;
def fgnu_runtime : Flag<"-fgnu-runtime">, Group<f_Group>;
def fheinous_gnu_extensions : Flag<"-fheinous-gnu-extensions">;
def filelist : Separate<"-filelist">, Flags<[LinkerInput]>;
def findirect_virtual_calls : Flag<"-findirect-virtual-calls">, Group<f_Group>;
def finline_functions : Flag<"-finline-functions">, Group<clang_ignored_f_Group>;
def finline : Flag<"-finline">, Group<clang_ignored_f_Group>;
def fkeep_inline_functions : Flag<"-fkeep-inline-functions">, Group<clang_ignored_f_Group>;
def flat__namespace : Flag<"-flat_namespace">;
def flax_vector_conversions : Flag<"-flax-vector-conversions">, Group<f_Group>;
def flimited_precision_EQ : Joined<"-flimited-precision=">, Group<f_Group>;
def flto : Flag<"-flto">, Group<f_Group>;
def fmath_errno : Flag<"-fmath-errno">, Group<f_Group>;
def fmerge_all_constants : Flag<"-fmerge-all-constants">, Group<f_Group>;
def fmessage_length_EQ : Joined<"-fmessage-length=">, Group<f_Group>;
def fms_extensions : Flag<"-fms-extensions">, Group<f_Group>;
def fmudflapth : Flag<"-fmudflapth">, Group<f_Group>;
def fmudflap : Flag<"-fmudflap">, Group<f_Group>;
def fnested_functions : Flag<"-fnested-functions">, Group<f_Group>;
def fnext_runtime : Flag<"-fnext-runtime">, Group<f_Group>;
def fno_asynchronous_unwind_tables : Flag<"-fno-asynchronous-unwind-tables">, Group<f_Group>;
def fno_assume_sane_operator_new : Flag<"-fno-assume-sane-operator-new">, Group<f_Group>;
def fno_blocks : Flag<"-fno-blocks">, Group<f_Group>;
def fno_builtin_strcat : Flag<"-fno-builtin-strcat">, Group<f_Group>;
def fno_builtin_strcpy : Flag<"-fno-builtin-strcpy">, Group<f_Group>;
def fno_builtin : Flag<"-fno-builtin">, Group<f_Group>;
def fno_caret_diagnostics : Flag<"-fno-caret-diagnostics">, Group<f_Group>;
def fno_color_diagnostics : Flag<"-fno-color-diagnostics">, Group<f_Group>;
def fno_common : Flag<"-fno-common">, Group<f_Group>;
def fno_constant_cfstrings : Flag<"-fno-constant-cfstrings">, Group<f_Group>;
def fno_diagnostics_fixit_info : Flag<"-fno-diagnostics-fixit-info">, Group<f_Group>;
def fno_diagnostics_show_option : Flag<"-fno-diagnostics-show-option">, Group<f_Group>;
def fno_dollars_in_identifiers : Flag<"-fno-dollars-in-identifiers">, Group<f_Group>;
def fno_eliminate_unused_debug_symbols : Flag<"-fno-eliminate-unused-debug-symbols">, Group<f_Group>;
def fno_exceptions : Flag<"-fno-exceptions">, Group<f_Group>;
def fno_inline_functions : Flag<"-fno-inline-functions">, Group<clang_ignored_f_Group>;
def fno_inline : Flag<"-fno-inline">, Group<clang_ignored_f_Group>;
def fno_keep_inline_functions : Flag<"-fno-keep-inline-functions">, Group<clang_ignored_f_Group>;
def fno_math_errno : Flag<"-fno-math-errno">, Group<f_Group>;
def fno_merge_all_constants : Flag<"-fno-merge-all-constants">, Group<f_Group>;
def fno_ms_extensions : Flag<"-fno-ms-extensions">, Group<f_Group>;
def fno_objc_legacy_dispatch : Flag<"-fno-objc-legacy-dispatch">, Group<f_Group>;
def fno_omit_frame_pointer : Flag<"-fno-omit-frame-pointer">, Group<f_Group>;
def fno_pascal_strings : Flag<"-fno-pascal-strings">, Group<f_Group>;
def fno_rtti : Flag<"-fno-rtti">, Group<f_Group>;
def fno_show_column : Flag<"-fno-show-column">, Group<f_Group>;
def fno_show_source_location : Flag<"-fno-show-source-location">, Group<f_Group>;
def fno_stack_protector : Flag<"-fno-stack-protector">, Group<f_Group>;
def fno_strict_aliasing : Flag<"-fno-strict-aliasing">, Group<clang_ignored_f_Group>;
def fno_threadsafe_statics : Flag<"-fno-threadsafe-statics">, Group<f_Group>;
def fno_unit_at_a_time : Flag<"-fno-unit-at-a-time">, Group<f_Group>;
def fno_unwind_tables : Flag<"-fno-unwind-tables">, Group<f_Group>;
def fno_working_directory : Flag<"-fno-working-directory">, Group<f_Group>;
def fno_zero_initialized_in_bss : Flag<"-fno-zero-initialized-in-bss">, Group<f_Group>;
def fobjc_atdefs : Flag<"-fobjc-atdefs">, Group<clang_ignored_f_Group>;
def fobjc_call_cxx_cdtors : Flag<"-fobjc-call-cxx-cdtors">, Group<clang_ignored_f_Group>;
def fobjc_gc_only : Flag<"-fobjc-gc-only">, Group<f_Group>;
def fobjc_gc : Flag<"-fobjc-gc">, Group<f_Group>;
def fobjc_legacy_dispatch : Flag<"-fobjc-legacy-dispatch">, Group<f_Group>;
def fobjc_new_property : Flag<"-fobjc-new-property">, Group<clang_ignored_f_Group>;
def fobjc_nonfragile_abi : Flag<"-fobjc-nonfragile-abi">, Group<f_Group>;
def fobjc_nonfragile_abi2 : Flag<"-fobjc-nonfragile-abi2">, Group<f_Group>;
def fobjc_sender_dependent_dispatch : Flag<"-fobjc-sender-dependent-dispatch">, Group<f_Group>;
def fobjc : Flag<"-fobjc">, Group<f_Group>;
def fomit_frame_pointer : Flag<"-fomit-frame-pointer">, Group<f_Group>;
def fopenmp : Flag<"-fopenmp">, Group<f_Group>;
def force__cpusubtype__ALL : Flag<"-force_cpusubtype_ALL">;
def force__flat__namespace : Flag<"-force_flat_namespace">;
def foutput_class_dir_EQ : Joined<"-foutput-class-dir=">, Group<f_Group>;
def fpascal_strings : Flag<"-fpascal-strings">, Group<f_Group>;
def fpch_preprocess : Flag<"-fpch-preprocess">, Group<f_Group>;
def fpic : Flag<"-fpic">, Group<f_Group>;
def fpie : Flag<"-fpie">, Group<f_Group>;
def fprofile_arcs : Flag<"-fprofile-arcs">, Group<f_Group>;
def fprofile_generate : Flag<"-fprofile-generate">, Group<f_Group>;
def framework : Separate<"-framework">, Flags<[LinkerInput]>;
def frtti : Flag<"-frtti">, Group<f_Group>;
def fsched_interblock : Flag<"-fsched-interblock">, Group<clang_ignored_f_Group>;
def fshort_enums : Flag<"-fshort-enums">, Group<clang_ignored_f_Group>;
def freorder_blocks : Flag<"-freorder-blocks">, Group<clang_ignored_f_Group>;
def fshort_wchar : Flag<"-fshort-wchar">, Group<f_Group>;
def fshow_source_location : Flag<"-fshow-source-location">, Group<f_Group>;
def fsigned_bitfields : Flag<"-fsigned-bitfields">, Group<f_Group>;
def fsigned_char : Flag<"-fsigned-char">, Group<f_Group>;
def fstack_protector_all : Flag<"-fstack-protector-all">, Group<f_Group>;
def fstack_protector : Flag<"-fstack-protector">, Group<f_Group>;
def fstrict_aliasing : Flag<"-fstrict-aliasing">, Group<clang_ignored_f_Group>;
def fsyntax_only : Flag<"-fsyntax-only">, Flags<[DriverOption]>;
def ftabstop_EQ : Joined<"-ftabstop=">, Group<f_Group>;
def ftemplate_depth_ : Joined<"-ftemplate-depth-">, Group<f_Group>;
def fterminated_vtables : Flag<"-fterminated-vtables">, Group<f_Group>;
def fthreadsafe_statics : Flag<"-fthreadsafe-statics">, Group<f_Group>;
def ftime_report : Flag<"-ftime-report">, Group<f_Group>;
def ftrapv : Flag<"-ftrapv">, Group<f_Group>;
def funit_at_a_time : Flag<"-funit-at-a-time">, Group<f_Group>;
def funsigned_bitfields : Flag<"-funsigned-bitfields">, Group<f_Group>;
def funsigned_char : Flag<"-funsigned-char">, Group<f_Group>;
def funwind_tables : Flag<"-funwind-tables">, Group<f_Group>;
def fverbose_asm : Flag<"-fverbose-asm">, Group<f_Group>;
def fvisibility_EQ : Joined<"-fvisibility=">, Group<f_Group>;
def fwritable_strings : Flag<"-fwritable-strings">, Group<f_Group>;
def fzero_initialized_in_bss : Flag<"-fzero-initialized-in-bss">, Group<f_Group>;
def f : Joined<"-f">, Group<f_Group>;
def g0 : Joined<"-g0">, Group<g_Group>;
def g3 : Joined<"-g3">, Group<g_Group>;
def gfull : Joined<"-gfull">, Group<g_Group>;
def gstabs : Joined<"-gstabs">, Group<g_Group>;
def gused : Joined<"-gused">, Group<g_Group>;
def g_Flag : Flag<"-g">, Group<g_Group>;
def g_Joined : Joined<"-g">, Group<g_Group>;
def headerpad__max__install__names : Joined<"-headerpad_max_install_names">;
def idirafter : JoinedOrSeparate<"-idirafter">, Group<clang_i_Group>;
def iframework : JoinedOrSeparate<"-iframework">, Group<clang_i_Group>;
def imacros : JoinedOrSeparate<"-imacros">, Group<clang_i_Group>;
def image__base : Separate<"-image_base">;
def include_ : JoinedOrSeparate<"-include">, Group<clang_i_Group>, EnumName<"include">;
def init : Separate<"-init">;
def install__name : Separate<"-install_name">;
def integrated_as : Flag<"-integrated-as">, Flags<[DriverOption]>;
def iprefix : JoinedOrSeparate<"-iprefix">, Group<clang_i_Group>;
def iquote : JoinedOrSeparate<"-iquote">, Group<clang_i_Group>;
def isysroot : JoinedOrSeparate<"-isysroot">, Group<clang_i_Group>;
def isystem : JoinedOrSeparate<"-isystem">, Group<clang_i_Group>;
def iwithprefixbefore : JoinedOrSeparate<"-iwithprefixbefore">, Group<clang_i_Group>;
def iwithprefix : JoinedOrSeparate<"-iwithprefix">, Group<clang_i_Group>;
def iwithsysroot : JoinedOrSeparate<"-iwithsysroot">, Group<i_Group>;
def i : Joined<"-i">, Group<i_Group>;
def keep__private__externs : Flag<"-keep_private_externs">;
def l : JoinedOrSeparate<"-l">, Flags<[LinkerInput]>;
def m32 : Flag<"-m32">, Group<m_Group>, Flags<[DriverOption]>;
def m3dnowa : Flag<"-m3dnowa">, Group<m_x86_Features_Group>;
def m3dnow : Flag<"-m3dnow">, Group<m_x86_Features_Group>;
def m64 : Flag<"-m64">, Group<m_Group>, Flags<[DriverOption]>;
def mabi_EQ : Joined<"-mabi=">, Group<m_Group>, Flags<[DriverOption]>;
def march_EQ : Joined<"-march=">, Group<m_Group>, Flags<[DriverOption]>;
def mcmodel_EQ : Joined<"-mcmodel=">, Group<m_Group>, Flags<[DriverOption]>;
def mconstant_cfstrings : Flag<"-mconstant-cfstrings">, Group<clang_ignored_m_Group>;
def mcpu_EQ : Joined<"-mcpu=">, Group<m_Group>, Flags<[DriverOption]>;
def mdynamic_no_pic : Joined<"-mdynamic-no-pic">, Group<m_Group>, Flags<[NoArgumentUnused]>;
def mfix_and_continue : Flag<"-mfix-and-continue">, Group<clang_ignored_m_Group>;
def mfloat_abi_EQ : Joined<"-mfloat-abi=">, Group<m_Group>;
def mfpu_EQ : Joined<"-mfpu=">, Group<m_Group>;
def mhard_float : Flag<"-mhard-float">, Group<m_Group>;
def miphoneos_version_min_EQ : Joined<"-miphoneos-version-min=">, Group<m_Group>, Flags<[DriverOption]>;
def mkernel : Flag<"-mkernel">, Group<m_Group>;
def mllvm : Separate<"-mllvm">;
def mmacosx_version_min_EQ : Joined<"-mmacosx-version-min=">, Group<m_Group>, Flags<[DriverOption]>;
def mmmx : Flag<"-mmmx">, Group<m_x86_Features_Group>;
def mno_3dnowa : Flag<"-mno-3dnowa">, Group<m_x86_Features_Group>;
def mno_3dnow : Flag<"-mno-3dnow">, Group<m_x86_Features_Group>;
def mno_constant_cfstrings : Flag<"-mno-constant-cfstrings">, Group<m_Group>;
def mno_mmx : Flag<"-mno-mmx">, Group<m_x86_Features_Group>;
def mno_pascal_strings : Flag<"-mno-pascal-strings">, Group<m_Group>;
def mno_red_zone : Flag<"-mno-red-zone">, Group<m_Group>;
def mno_soft_float : Flag<"-mno-soft-float">, Group<m_Group>;
def mno_sse2 : Flag<"-mno-sse2">, Group<m_x86_Features_Group>;
def mno_sse3 : Flag<"-mno-sse3">, Group<m_x86_Features_Group>;
def mno_sse4a : Flag<"-mno-sse4a">, Group<m_x86_Features_Group>;
def mno_sse4 : Flag<"-mno-sse4">, Group<m_x86_Features_Group>;
def mno_sse4_1 : Flag<"-mno-sse4.1">, Group<m_x86_Features_Group>;
def mno_sse4_2 : Flag<"-mno-sse4.2">, Group<m_x86_Features_Group>;
def mno_sse : Flag<"-mno-sse">, Group<m_x86_Features_Group>;
def mno_ssse3 : Flag<"-mno-ssse3">, Group<m_x86_Features_Group>;

def mno_thumb : Flag<"-mno-thumb">, Group<m_Group>;
def marm : Flag<"-marm">, Alias<mno_thumb>;

def mno_warn_nonportable_cfstrings : Flag<"-mno-warn-nonportable-cfstrings">, Group<m_Group>;
def mpascal_strings : Flag<"-mpascal-strings">, Group<m_Group>;
def mred_zone : Flag<"-mred-zone">, Group<m_Group>;
def msoft_float : Flag<"-msoft-float">, Group<m_Group>;
def msse2 : Flag<"-msse2">, Group<m_x86_Features_Group>;
def msse3 : Flag<"-msse3">, Group<m_x86_Features_Group>;
def msse4a : Flag<"-msse4a">, Group<m_x86_Features_Group>;
def msse4 : Flag<"-msse4">, Group<m_x86_Features_Group>;
def msse4_1 : Flag<"-msse4.1">, Group<m_x86_Features_Group>;
def msse4_2 : Flag<"-msse4.2">, Group<m_x86_Features_Group>;
def msse : Flag<"-msse">, Group<m_x86_Features_Group>;
def mssse3 : Flag<"-mssse3">, Group<m_x86_Features_Group>;
def mthumb : Flag<"-mthumb">, Group<m_Group>;
def mtune_EQ : Joined<"-mtune=">, Group<m_Group>;
def multi__module : Flag<"-multi_module">;
def multiply__defined__unused : Separate<"-multiply_defined_unused">;
def multiply__defined : Separate<"-multiply_defined">;
def mwarn_nonportable_cfstrings : Flag<"-mwarn-nonportable-cfstrings">, Group<m_Group>;
def m_Separate : Separate<"-m">, Group<m_Group>;
def m_Joined : Joined<"-m">, Group<m_Group>;
def no_canonical_prefixes : Flag<"-no-canonical-prefixes">, Flags<[HelpHidden]>,
  HelpText<"Use relative instead of canonical paths">;
def no_cpp_precomp : Flag<"-no-cpp-precomp">;
def no_integrated_as : Flag<"-no-integrated-as">, Flags<[DriverOption]>;
def no_integrated_cpp : Flag<"-no-integrated-cpp">, Flags<[DriverOption]>;
def no__dead__strip__inits__and__terms : Flag<"-no_dead_strip_inits_and_terms">;
def nobuiltininc : Flag<"-nobuiltininc">;
def nodefaultlibs : Flag<"-nodefaultlibs">;
def nofixprebinding : Flag<"-nofixprebinding">;
def nolibc : Flag<"-nolibc">;
def nomultidefs : Flag<"-nomultidefs">;
def noprebind : Flag<"-noprebind">;
def noseglinkedit : Flag<"-noseglinkedit">;
def nostartfiles : Flag<"-nostartfiles">;
def nostdinc : Flag<"-nostdinc">;
def nostdlib : Flag<"-nostdlib">;
def object : Flag<"-object">;
def o : JoinedOrSeparate<"-o">, Flags<[DriverOption, RenderAsInput]>,
  HelpText<"Write output to <file>">, MetaVarName<"<file>">;
def pagezero__size : JoinedOrSeparate<"-pagezero_size">;
def pass_exit_codes : Flag<"-pass-exit-codes">, Flags<[Unsupported]>;
def pedantic_errors : Flag<"-pedantic-errors">, Group<pedantic_Group>;
def pedantic : Flag<"-pedantic">, Group<pedantic_Group>;
def pg : Flag<"-pg">;
def pipe : Flag<"-pipe">,
  HelpText<"Use pipes between commands, when possible">;
def prebind__all__twolevel__modules : Flag<"-prebind_all_twolevel_modules">;
def prebind : Flag<"-prebind">;
def preload : Flag<"-preload">;
def print_file_name_EQ : Joined<"-print-file-name=">,
  HelpText<"Print the full library path of <file>">, MetaVarName<"<file>">;
def print_ivar_layout : Flag<"-print-ivar-layout">;
def print_libgcc_file_name : Flag<"-print-libgcc-file-name">,
  HelpText<"Print the library path for \"libgcc.a\"">;
def print_multi_directory : Flag<"-print-multi-directory">;
def print_multi_lib : Flag<"-print-multi-lib">;
def print_multi_os_directory : Flag<"-print-multi-os-directory">;
def print_prog_name_EQ : Joined<"-print-prog-name=">,
  HelpText<"Print the full program path of <name>">, MetaVarName<"<name>">;
def print_search_dirs : Flag<"-print-search-dirs">,
  HelpText<"Print the paths used for finding libraries and programs">;
def private__bundle : Flag<"-private_bundle">;
def pthreads : Flag<"-pthreads">;
def pthread : Flag<"-pthread">;
def p : Flag<"-p">;
def read__only__relocs : Separate<"-read_only_relocs">;
def remap : Flag<"-remap">;
def rewrite_objc : Flag<"-rewrite-objc">, Flags<[DriverOption]>,
  HelpText<"Rewrite Objective-C source to C++">;
def rpath : Separate<"-rpath">, Flags<[LinkerInput]>;
def r : Flag<"-r">;
def save_temps : Flag<"-save-temps">, Flags<[DriverOption]>,
  HelpText<"Save intermediate compilation results">;
def sectalign : MultiArg<"-sectalign", 3>;
def sectcreate : MultiArg<"-sectcreate", 3>;
def sectobjectsymbols : MultiArg<"-sectobjectsymbols", 2>;
def sectorder : MultiArg<"-sectorder", 3>;
def seg1addr : JoinedOrSeparate<"-seg1addr">;
def seg__addr__table__filename : Separate<"-seg_addr_table_filename">;
def seg__addr__table : Separate<"-seg_addr_table">;
def segaddr : MultiArg<"-segaddr", 2>;
def segcreate : MultiArg<"-segcreate", 3>;
def seglinkedit : Flag<"-seglinkedit">;
def segprot : MultiArg<"-segprot", 3>;
def segs__read__only__addr : Separate<"-segs_read_only_addr">;
def segs__read__write__addr : Separate<"-segs_read_write_addr">;
def segs__read__ : Joined<"-segs_read_">;
def shared_libgcc : Flag<"-shared-libgcc">;
def shared : Flag<"-shared">;
def single__module : Flag<"-single_module">;
def specs_EQ : Joined<"-specs=">;
def specs : Separate<"-specs">, Flags<[Unsupported]>;
def static_libgcc : Flag<"-static-libgcc">;
def static : Flag<"-static">, Flags<[NoArgumentUnused]>;
def std_default_EQ : Joined<"-std-default=">;
def std_EQ : Joined<"-std=">;
def sub__library : JoinedOrSeparate<"-sub_library">;
def sub__umbrella : JoinedOrSeparate<"-sub_umbrella">;
def s : Flag<"-s">;
def time : Flag<"-time">,
  HelpText<"Time individual commands">;
def traditional_cpp : Flag<"-traditional-cpp">;
def traditional : Flag<"-traditional">;
def trigraphs : Flag<"-trigraphs">;
def twolevel__namespace__hints : Flag<"-twolevel_namespace_hints">;
def twolevel__namespace : Flag<"-twolevel_namespace">;
def t : Flag<"-t">;
def umbrella : Separate<"-umbrella">;
def undefined : JoinedOrSeparate<"-undefined">, Group<u_Group>;
def undef : Flag<"-undef">, Group<u_Group>;
def unexported__symbols__list : Separate<"-unexported_symbols_list">;
def u : JoinedOrSeparate<"-u">, Group<u_Group>;
def v : Flag<"-v">,
  HelpText<"Show commands to run and use verbose output">;
def weak_l : Joined<"-weak-l">, Flags<[LinkerInput]>;
def weak__framework : Separate<"-weak_framework">, Flags<[LinkerInput]>;
def weak__library : Separate<"-weak_library">, Flags<[LinkerInput]>;
def weak__reference__mismatches : Separate<"-weak_reference_mismatches">;
def whatsloaded : Flag<"-whatsloaded">;
def whyload : Flag<"-whyload">;
def w : Flag<"-w">;
def x : JoinedOrSeparate<"-x">, Flags<[DriverOption]>,
  HelpText<"Treat subsequent input files as having type <language>">,
  MetaVarName<"<language>">;
def y : Joined<"-y">;

// Double dash options, which are usually an alias for one of the previous
// options.

def _CLASSPATH_EQ : Joined<"--CLASSPATH=">, Alias<fclasspath_EQ>;
def _CLASSPATH : Separate<"--CLASSPATH">, Alias<fclasspath_EQ>, Flags<[RenderJoined]>;
def _all_warnings : Flag<"--all-warnings">, Alias<Wall>;
def _analyze_auto : Flag<"--analyze-auto">, Flags<[DriverOption]>;
def _analyzer_no_default_checks : Flag<"--analyzer-no-default-checks">, Flags<[DriverOption]>;
def _analyzer_output : JoinedOrSeparate<"--analyzer-output">, Flags<[DriverOption]>;
def _analyze : Flag<"--analyze">, Flags<[DriverOption]>,
  HelpText<"Run the static analyzer">;
def _ansi : Flag<"--ansi">, Alias<ansi>;
def _assemble : Flag<"--assemble">, Alias<S>;
def _assert_EQ : Joined<"--assert=">, Alias<A>, Flags<[RenderSeparate]>;
def _assert : Separate<"--assert">, Alias<A>;
def _bootclasspath_EQ : Joined<"--bootclasspath=">, Alias<fbootclasspath_EQ>;
def _bootclasspath : Separate<"--bootclasspath">, Alias<fbootclasspath_EQ>, Flags<[RenderJoined]>;
def _classpath_EQ : Joined<"--classpath=">, Alias<fclasspath_EQ>;
def _classpath : Separate<"--classpath">, Alias<fclasspath_EQ>, Flags<[RenderJoined]>;
def _combine : Flag<"--combine">, Alias<combine>, Flags<[Unsupported]>;
def _comments_in_macros : Flag<"--comments-in-macros">, Alias<CC>;
def _comments : Flag<"--comments">, Alias<C>;
def _compile : Flag<"--compile">, Alias<c>;
def _constant_cfstrings : Flag<"--constant-cfstrings">;
def _coverage : Flag<"--coverage">, Alias<coverage>;
def _debug_EQ : Joined<"--debug=">, Alias<g_Flag>, Flags<[Unsupported]>;
def _debug : Flag<"--debug">, Alias<g_Flag>, Flags<[Unsupported]>;
def _define_macro_EQ : Joined<"--define-macro=">, Alias<D>;
def _define_macro : Separate<"--define-macro">, Alias<D>, Flags<[RenderJoined]>;
def _dependencies : Flag<"--dependencies">, Alias<M>;
def _encoding_EQ : Joined<"--encoding=">, Alias<fencoding_EQ>;
def _encoding : Separate<"--encoding">, Alias<fencoding_EQ>, Flags<[RenderJoined]>;
def _entry : Flag<"--entry">, Alias<e>;
def _extdirs_EQ : Joined<"--extdirs=">, Alias<fextdirs_EQ>;
def _extdirs : Separate<"--extdirs">, Alias<fextdirs_EQ>, Flags<[RenderJoined]>;
def _extra_warnings : Flag<"--extra-warnings">, Alias<W_Joined>;
def _for_linker_EQ : Joined<"--for-linker=">, Alias<Xlinker>, Flags<[LinkerInput, RenderAsInput, RenderSeparate]>;
def _for_linker : Separate<"--for-linker">, Alias<Xlinker>, Flags<[LinkerInput, RenderAsInput]>;
def _force_link_EQ : Joined<"--force-link=">, Alias<u>, Flags<[RenderSeparate]>;
def _force_link : Separate<"--force-link">, Alias<u>;
def _help_hidden : Flag<"--help-hidden">;
def _help : Flag<"--help">,
  HelpText<"Display available options">;
def _imacros_EQ : Joined<"--imacros=">, Alias<imacros>, Flags<[RenderSeparate]>;
def _imacros : Separate<"--imacros">, Alias<imacros>;
def _include_barrier : Flag<"--include-barrier">, Alias<I_>;
def _include_directory_after_EQ : Joined<"--include-directory-after=">, Alias<idirafter>, Flags<[RenderSeparate]>;
def _include_directory_after : Separate<"--include-directory-after">, Alias<idirafter>;
def _include_directory_EQ : Joined<"--include-directory=">, Alias<I>;
def _include_directory : Separate<"--include-directory">, Alias<I>, Flags<[RenderJoined]>;
def _include_prefix_EQ : Joined<"--include-prefix=">, Alias<iprefix>, Flags<[RenderSeparate]>;
def _include_prefix : Separate<"--include-prefix">, Alias<iprefix>;
def _include_with_prefix_after_EQ : Joined<"--include-with-prefix-after=">, Alias<iwithprefix>, Flags<[RenderSeparate]>;
def _include_with_prefix_after : Separate<"--include-with-prefix-after">, Alias<iwithprefix>;
def _include_with_prefix_before_EQ : Joined<"--include-with-prefix-before=">, Alias<iwithprefixbefore>, Flags<[RenderSeparate]>;
def _include_with_prefix_before : Separate<"--include-with-prefix-before">, Alias<iwithprefixbefore>;
def _include_with_prefix_EQ : Joined<"--include-with-prefix=">, Alias<iwithprefix>, Flags<[RenderSeparate]>;
def _include_with_prefix : Separate<"--include-with-prefix">, Alias<iwithprefix>;
def _include_EQ : Joined<"--include=">, Alias<include_>, Flags<[RenderSeparate]>;
def _include : Separate<"--include">, Alias<include_>;
def _language_EQ : Joined<"--language=">, Alias<x>, Flags<[RenderSeparate]>;
def _language : Separate<"--language">, Alias<x>;
def _library_directory_EQ : Joined<"--library-directory=">, Alias<L>, Flags<[RenderSeparate]>;
def _library_directory : Separate<"--library-directory">, Alias<L>;
def _machine__EQ : Joined<"--machine-=">, Alias<m_Joined>, Flags<[Unsupported]>;
def _machine_ : Joined<"--machine-">, Alias<m_Joined>, Flags<[Unsupported]>;
def _machine_EQ : Joined<"--machine=">, Alias<m_Joined>;
def _machine : Separate<"--machine">, Alias<m_Joined>, Flags<[RenderJoined]>;
def _no_integrated_cpp : Flag<"--no-integrated-cpp">, Alias<no_integrated_cpp>;
def _no_line_commands : Flag<"--no-line-commands">, Alias<P>;
def _no_standard_includes : Flag<"--no-standard-includes">, Alias<nostdinc>;
def _no_standard_libraries : Flag<"--no-standard-libraries">, Alias<nostdlib>;
def _no_undefined : Flag<"--no-undefined">, Flags<[LinkerInput]>;
def _no_warnings : Flag<"--no-warnings">, Alias<w>;
def _optimize_EQ : Joined<"--optimize=">, Alias<O>, Flags<[Unsupported]>;
def _optimize : Flag<"--optimize">, Alias<O>, Flags<[Unsupported]>;
def _output_class_directory_EQ : Joined<"--output-class-directory=">, Alias<foutput_class_dir_EQ>;
def _output_class_directory : Separate<"--output-class-directory">, Alias<foutput_class_dir_EQ>, Flags<[RenderJoined]>;
def _output_EQ : Joined<"--output=">, Alias<o>, Flags<[RenderSeparate]>;
def _output : Separate<"--output">, Alias<o>;
def _param : Separate<"--param">;
def _param_EQ : Joined<"--param=">, Alias<_param>, Flags<[RenderSeparate]>;
def _pass_exit_codes : Flag<"--pass-exit-codes">, Alias<pass_exit_codes>;
def _pedantic_errors : Flag<"--pedantic-errors">, Alias<pedantic_errors>;
def _pedantic : Flag<"--pedantic">, Alias<pedantic>;
def _pipe : Flag<"--pipe">, Alias<pipe>, Flags<[DriverOption]>;
def _prefix_EQ : Joined<"--prefix=">, Alias<B>, Flags<[RenderSeparate]>;
def _prefix : Separate<"--prefix">, Alias<B>;
def _preprocess : Flag<"--preprocess">, Alias<E>;
def _print_file_name_EQ : Joined<"--print-file-name=">, Alias<print_file_name_EQ>;
def _print_file_name : Separate<"--print-file-name">, Alias<print_file_name_EQ>;
def _print_libgcc_file_name : Flag<"--print-libgcc-file-name">, Alias<print_libgcc_file_name>;
def _print_missing_file_dependencies : Flag<"--print-missing-file-dependencies">, Alias<MG>;
def _print_multi_directory : Flag<"--print-multi-directory">, Alias<print_multi_directory>;
def _print_multi_lib : Flag<"--print-multi-lib">, Alias<print_multi_lib>;
def _print_multi_os_directory : Flag<"--print-multi-os-directory">, Alias<print_multi_os_directory>;
def _print_prog_name_EQ : Joined<"--print-prog-name=">, Alias<print_prog_name_EQ>;
def _print_prog_name : Separate<"--print-prog-name">, Alias<print_prog_name_EQ>;
def _print_search_dirs : Flag<"--print-search-dirs">, Alias<print_search_dirs>;
def _profile_blocks : Flag<"--profile-blocks">, Alias<a>;
def _profile : Flag<"--profile">, Alias<p>;
def _relocatable_pch : Flag<"--relocatable-pch">,
  HelpText<"Build a relocatable precompiled header">;
def _resource_EQ : Joined<"--resource=">, Alias<fcompile_resource_EQ>;
def _resource : Separate<"--resource">, Alias<fcompile_resource_EQ>, Flags<[RenderJoined]>;
def _save_temps : Flag<"--save-temps">, Alias<save_temps>;
def _shared : Flag<"--shared">, Alias<shared>;
def _signed_char : Flag<"--signed-char">, Alias<fsigned_char>;
def _specs_EQ : Joined<"--specs=">, Alias<specs_EQ>, Flags<[Unsupported]>;
def _specs : Separate<"--specs">, Alias<specs_EQ>, Flags<[RenderJoined, Unsupported]>;
def _static : Flag<"--static">, Alias<static>;
def _std_EQ : Joined<"--std=">, Alias<std_EQ>;
def _std : Separate<"--std">, Alias<std_EQ>, Flags<[RenderJoined]>;
def _sysroot_EQ : Joined<"--sysroot=">;
def _sysroot : Separate<"--sysroot">, Alias<_sysroot_EQ>, Flags<[RenderJoined]>;
def _target_help : Flag<"--target-help">;
def _trace_includes : Flag<"--trace-includes">, Alias<H>;
def _traditional_cpp : Flag<"--traditional-cpp">, Alias<traditional_cpp>;
def _traditional : Flag<"--traditional">, Alias<traditional>;
def _trigraphs : Flag<"--trigraphs">, Alias<trigraphs>;
def _undefine_macro_EQ : Joined<"--undefine-macro=">, Alias<U>;
def _undefine_macro : Separate<"--undefine-macro">, Alias<U>, Flags<[RenderJoined]>;
def _unsigned_char : Flag<"--unsigned-char">, Alias<funsigned_char>;
def _user_dependencies : Flag<"--user-dependencies">, Alias<MM>;
def _verbose : Flag<"--verbose">, Alias<v>;
def _version : Flag<"--version">;
def _warn__EQ : Joined<"--warn-=">, Alias<W_Joined>, Flags<[Unsupported]>;
def _warn_ : Joined<"--warn-">, Alias<W_Joined>, Flags<[Unsupported]>;
def _write_dependencies : Flag<"--write-dependencies">, Alias<MD>;
def _write_user_dependencies : Flag<"--write-user-dependencies">, Alias<MMD>;
def _ : Joined<"--">, Alias<f>, Flags<[Unsupported]>;
