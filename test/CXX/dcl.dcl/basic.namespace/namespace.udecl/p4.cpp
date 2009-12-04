// RUN: clang-cc -fsyntax-only -verify %s

// C++03 [namespace.udecl]p4:
//   A using-declaration used as a member-declaration shall refer to a
//   member of a base class of the class being defined, shall refer to
//   a member of an anonymous union that is a member of a base class
//   of the class being defined, or shall refer to an enumerator for
//   an enumeration type that is a member of a base class of the class
//   being defined.

// There is no directly analogous paragraph in C++0x, and the feature
// works sufficiently differently there that it needs a separate test.

namespace test0 {
  namespace NonClass {
    typedef int type;
    struct hiding {};
    int hiding;
    static union { double union_member; };
    enum tagname { enumerator };
  }

  class Test0 {
    using NonClass::type; // expected-error {{not a base class}}
    using NonClass::hiding; // expected-error {{not a base class}}
    using NonClass::union_member; // expected-error {{not a base class}}
    using NonClass::enumerator; // expected-error {{not a base class}}
  };
}

struct Opaque0 {};

namespace test1 {
  struct A {
    typedef int type;
    struct hiding {}; // expected-note {{previous use is here}}
    Opaque0 hiding;
    union { double union_member; };
    enum tagname { enumerator };
  };

  struct B : A {
    using A::type;
    using A::hiding;
    using A::union_member;
    using A::enumerator;
    using A::tagname;

    void test0() {
      type t = 0;
    }

    void test1() {
      typedef struct A::hiding local;
      struct hiding _ = local();
    }

    void test2() {
      union hiding _; // expected-error {{tag type that does not match previous}}
    }

    void test3() {
      char array[sizeof(union_member) == sizeof(double) ? 1 : -1];
    }

    void test4() {
      enum tagname _ = enumerator;
    }

    void test5() {
      Opaque0 _ = hiding;
    }
  };
}

namespace test2 {
  struct A {
    typedef int type;
    struct hiding {}; // expected-note {{previous use is here}}
    int hiding;
    union { double union_member; };
    enum tagname { enumerator };
  };

  template <class T> struct B : A {
    using A::type;
    using A::hiding;
    using A::union_member;
    using A::enumerator;
    using A::tagname;

    void test0() {
      type t = 0;
    }

    void test1() {
      typedef struct A::hiding local;
      struct hiding _ = local();
    }

    void test2() {
      union hiding _; // expected-error {{tag type that does not match previous}}
    }

    void test3() {
      char array[sizeof(union_member) == sizeof(double) ? 1 : -1];
    }

    void test4() {
      enum tagname _ = enumerator;
    }

    void test5() {
      Opaque0 _ = hiding;
    }
  };
}

namespace test3 {
  struct hiding {};

  template <class T> struct A {
    typedef int type; // expected-note {{target of using declaration}}
    struct hiding {};
    Opaque0 hiding; // expected-note {{target of using declaration}}
    union { double union_member; }; // expected-note {{target of using declaration}}
    enum tagname { enumerator }; // expected-note 2 {{target of using declaration}}
  };

  template <class T> struct B : A<T> {
    using A<T>::type; // expected-error {{dependent using declaration resolved to type without 'typename'}}
    using A<T>::hiding;
    using A<T>::union_member;
    using A<T>::enumerator;
    using A<T>::tagname; // expected-error {{dependent using declaration resolved to type without 'typename'}}

    // FIXME: re-enable these when the various bugs involving tags are fixed
#if 0
    void test1() {
      typedef struct A<T>::hiding local;
      struct hiding _ = local();
    }

    void test2() {
      typedef struct A<T>::hiding local;
      union hiding _ = local();
    }
#endif

    void test3() {
      char array[sizeof(union_member) == sizeof(double) ? 1 : -1];
    }

#if 0
    void test4() {
      enum tagname _ = enumerator;
    }
#endif

    void test5() {
      Opaque0 _ = hiding;
    }
  };

  template struct B<int>; // expected-note {{in instantiation}}

  template <class T> struct C : A<T> {
    using typename A<T>::type;
    using typename A<T>::hiding; // expected-error {{'typename' keyword used on a non-type}}
    using typename A<T>::union_member; // expected-error {{'typename' keyword used on a non-type}}
    using typename A<T>::enumerator; // expected-error {{'typename' keyword used on a non-type}}

    void test6() {
      type t = 0;
    }

    void test7() {
      Opaque0 _ = hiding; // expected-error {{expected '(' for function-style cast or type construction}}
    }
  };

  template struct C<int>; // expected-note {{in instantiation}}
}
