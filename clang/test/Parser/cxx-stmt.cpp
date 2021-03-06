// RUN: %clang_cc1 -fsyntax-only -verify %s

void f1()
{
  try {
    ;
  } catch(int i) {
    ;
  } catch(...) {
  }
}

void f2()
{
  try; // expected-error {{expected '{'}}

  try {}
  catch; // expected-error {{expected '('}}

  try {}
  catch (...); // expected-error {{expected '{'}}

  try {}
  catch {} // expected-error {{expected '('}}
}

void f3() try {
} catch(...) {
}

struct A {
  int i;
  A(int);
  A(char);
  A() try : i(0) {} catch(...) {}
  void f() try {} catch(...) {}
  A(float) : i(0) try {} // expected-error {{expected '{' or ','}}
};

A::A(char) : i(0) try {} // expected-error {{expected '{' or ','}}
A::A(int j) try : i(j) {} catch(...) {}



// PR5740
struct Type { };

enum { Type } Kind;
void f4() {
  int i = 0;
  switch (Kind) {
    case Type: i = 7; break;  // no error.
  }
}

// PR5500
void f5() {
  asm volatile ("":: :"memory");
  asm volatile ("": ::"memory");
}
