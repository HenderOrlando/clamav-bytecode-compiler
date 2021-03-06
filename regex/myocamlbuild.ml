open Ocamlbuild_plugin;;
open Command;;
open Unix;;

let static = true
let re2_lib = "../re2/obj/libre2.a"
let re2_include = "-I../re2/";;

let cc = A"cc";;
let ocamlfind =
  try Sys.getenv "OCAMLFIND"
  with Not_found -> "ocamlfind";;

let ocamlfind_query pkg =
  let cmd = Printf.sprintf "%s query %s" ocamlfind (Filename.quote pkg) in
  Ocamlbuild_pack.My_unix.run_and_open cmd (fun ic ->
    input_line ic);;

let ocamlfind_path =
  let cmd = "ocamlfind printconf stdlib" in
  Ocamlbuild_pack.My_unix.run_and_open cmd (fun ic ->
    input_line ic);;

let version =
  Ocamlbuild_pack.My_unix.run_and_open "(git describe --always --dirty || echo 'exported')" (fun ic ->
    input_line ic);;

let time =
  let tm = Unix.gmtime (Unix.time ()) in
  Printf.sprintf "%04d/%02d/%02d %02dh UTC"
    (tm.tm_year + 1900) (tm.tm_mon + 1) tm.tm_mday
    tm.tm_hour

let make_version _ _ =
  let cmd =
    Printf.sprintf "let version = %S
let compile_time = %S"
      version time
  in
  Cmd (S [ A "echo"; Quote (Sh cmd); Sh ">"; P "version.ml" ]);;

dispatch begin function
 | After_rules ->
     ocaml_lib ~extern:true ~dir:(ocamlfind_query "extlib") "extLib";

     rule "C++ files"
     ~prod:("%.o")
     ~dep:"%.cc"
     begin fun env _ ->
       let c = env "%.cc" in
       Cmd(S[cc; P c;A"-I";A ocamlfind_path;A"-c";A re2_include])
     end;

     (* When one make a C library that use the re2 with ocamlmklib,
        then issue these flags. *)
     flag ["ocamlmklib"; "c"; "use_re2"]
     (S[A"-lstdc++"]);

     (* If `static' is true then every ocaml link in bytecode will add -custom *)
     if static then begin
       flag ["link"; "ocaml";"byte"] (A"-custom");
       flag ["ocamlmklib"; "c"] (A"-custom");
     end;

     (* When ocaml link something that use the libre2internal,
     then oe need that file to be up to date. *)
     dep ["link"; "ocaml"; "use_libre2internal"] ["libre2internal.a"];

     (* re2internal is an ocaml library.
        This will declare use_re2internal and include_re2internal *)
     ocaml_lib "re2internal";
     flag ["link"; "library"; "ocaml"; "byte"; "use_libre2internal"]
     (S[A"-dllib";A"-lre2internal";A"-cclib";A"-lre2internal";
     A"-cclib"; A re2_lib;A"-cclib";A"-lstdc++"]);

     flag ["link"; "library"; "ocaml"; "native"; "use_libre2internal"]
     (S[A"-cclib";A"-lre2internal";
     A"-cclib"; A re2_lib; A"-cclib";A"-lstdc++";A"-cclib";A"-pthread"]);

     flag ["link"; "ocaml"; "use_re2internal"]
     (S[A"-I";A"."]);

     rule "version.ml" ~prod: "version.ml" make_version
 | _ -> ()
 end

