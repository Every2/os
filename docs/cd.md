# How to use OS in a CD

Run:

```
make
``` 

Now create a folder and run this command:

```
mkdir -p isodir/boot/grub
cp os.bin isodir/boot/os.bin && cp -r grub /isodir/boot/grub/grub.cfg
&& grub-mkrescue -o os.iso isodir
```

If you receive the error `Could not read from CD-ROM (code 0009) when
trying to boot the iso image in QEMU`, install the `mtools` and `grub-pc-bin` packages.

To run in qemu, run:
``` 
qemu-system-i386 -cdrom os.iso
``` 
