# Prerequisites

# Cross Compile

This project uses `GCC 15.2.0` with Binutils `2.45`. Follow the
instructions to compile it successfully.

## Set environment variables in your shell:

```shell
export PREFIX="path/to/folder"
export TARGET=i686-elf
export PATH="$PREFIX/bin:$PATH"
```

## Binutils
[Download a copy of Binutils 2.45](https://ftp.gnu.org/gnu/binutils/)
and extract.


Go to binutils dir and create a folder inside it:
```
mkdir build
``` 

and run:

``` 
../configure --target=$TARGET --prefix="$PREFIX" --with-sysroot
--disable-nls --disable-werror
make
make install
``` 



## GCC

[Download a copy of
GCC](https://mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-15.2.0/)
and extract.


Create a folder:


Note: I was unable to compile gcc the same way as binutils, it was necessary to create a folder outside the gcc directory for everything to work correctly.

```
mkdir build-gcc
cd build-gcc
```

Now run:

```
../gcc.15.0.2/configure --target=$TARGET --prefix="$PREFIX"
--disable-nls --enable-languages=c --without-headers
--disable-hosted-libstdcxx
make all-gcc
make all-target-libgcc
make all-target-libstdc++-v3
make install-gcc
make install-target-libgcc
make install-target-libstdc++-v3

```


