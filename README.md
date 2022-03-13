System_Random
[![License](https://img.shields.io/github/license/AntonMeep/system_random.svg?color=blue)](https://github.com/AntonMeep/system_random/blob/master/LICENSE.txt)
[![Alire crate](https://img.shields.io/endpoint?url=https://alire.ada.dev/badges/system_random.json)](https://alire.ada.dev/crates/system_random.html)
[![GitHub release](https://img.shields.io/github/release/AntonMeep/system_random.svg)](https://github.com/AntonMeep/system_random/releases/latest)
=======

System_Random provides portable interface to system's sources of randomness,
which are assumed to be cryptographically secure. This crate features rather
low-level implementation and is intended to be used to seed some high-quality
PRNG which would be adequate for your specific use case.

This crate was inspired by a similar [getrandom](https://github.com/rust-random/getrandom)
crate for Rust, but is a completely original project.

# Sources of randomness

System_Random utilizes different system facilities under the hood, based on
what OS is being used. Unlike other similar projects, no fall-back is provided
for the situations when, say, program is being run on an outdated version of OS.
Instead, latest and greatest system sources of randomness are used.

| Environment | Source |
|----|--------|
| Windows | [BCryptGenRandom](https://docs.microsoft.com/en-us/windows/win32/api/bcrypt/nf-bcrypt-bcryptgenrandom) |
| Linux | [getentropy](https://man7.org/linux/man-pages/man3/getentropy.3.html) |
| MacOS | [getentropy](https://opensource.apple.com/source/xnu/xnu-6153.41.3/bsd/man/man2/getentropy.2.auto.html) |
| Anything else | getentropy if available |

# Explanation

## Windows

[BCryptGenRandom](https://docs.microsoft.com/en-us/windows/win32/api/bcrypt/nf-bcrypt-bcryptgenrandom)
is a part of [Cryptography API: Next Generation](https://docs.microsoft.com/en-us/windows/win32/seccng/cng-portal),
and is the new preferred source of randomness on this platform. Requires
linking to `bcrypt` system library.

> Availability: CNG is supported since Windows Server 2008 and Windows Vista,
however due to the flags System_Random is using, Windows Vista is not supported.
> Good thing it reached its end-of-life in 2017.

## Linux

[getentropy](https://man7.org/linux/man-pages/man3/getentropy.3.html) is used,
which is not necessarily a system call, but rather a function of Glibc built
on top of `getrandom` system call.

Most common way of getting random data on Linux is reading from `/dev/(u)random`,
however this method has quite a few cons:

- To read from file, a file descriptor must be stored somewhere, which means
that now there's a global state introduced into the program. This is never a
good thing

- Synchronizing this global state between multiple threads can be cumbersome

- This method is susceptible to file-descriptor attacks

Because of that, `getentropy` is used.

> Availability: Introduced in Glibc v2.25 (February 5, 2017), depends on
`getrandom` syscall, introduced in Linux v3.17 (October 5, 2014).

## MacOS

[getentropy](https://opensource.apple.com/source/xnu/xnu-6153.41.3/bsd/man/man2/getentropy.2.auto.html) is also used on MacOS, however it is a system function on this platform.

> Availability: Introduced in MacOS v10.12 (June 13, 2016).

## Other platforms

While not proven to work on other platforms, System_Random should work just
fine on any system that provides `getentropy`.

For example, OpenBSD since v5.6 (November 1, 2015)
[provides](https://man.openbsd.org/getentropy.2) such function, therefore this
crate can be used without any problem.

On the contrary, Solaris also provides a function with the same name, and
it should also be possible to use System_Random on this system, however
`getentropy` has [different](https://web.archive.org/web/20170802164413/https://blogs.oracle.com/darren/solaris-new-system-calls:-getentropy2-and-getrandom2)
meaning on this platform, and therefore its usage will be different.
