# Bits and bobs, hacks and docs
for Unigi cloudkey Gen 1,2

If you found something about, and you can't find it here, please let me, to build it a comprehensive collection.


UART (console) seerings 115200,8,1,n,n

user / password

Recovery mode: root / ubnt

normal mode:   ubnt / ubnt       (until you don't override in contorller settings)



boot.txt:
shows a boot progress on console (UART) from switch on.

boot_recovery.txt:
shows a boot progress on console (UART) from switch on into a recovery mode.



ls /dev/disk/by-partlabel/ -1aos

0 lrwxrwxrwx 1 root  15 Dec  4 16:07 config -> ../../mmcblk0p2

0 lrwxrwxrwx 1 root  15 Dec  4 16:07 data -> ../../mmcblk1p1

0 lrwxrwxrwx 1 root  15 Dec  4 16:07 factory -> ../../mmcblk0p3

0 lrwxrwxrwx 1 root  15 Dec  4 16:30 kernel -> ../../mmcblk0p4

0 lrwxrwxrwx 1 root  15 Dec  4 16:07 recovery -> ../../mmcblk0p5

0 lrwxrwxrwx 1 root  15 Dec  4 16:07 rootfs -> ../../mmcblk0p6

0 lrwxrwxrwx 1 root  15 Dec  4 16:07 uboot -> ../../mmcblk0p1

0 lrwxrwxrwx 1 root  15 Dec  4 16:07 userdata -> ../../mmcblk0p7     (actual rootfs)

0 lrwxrwxrwx 1 root  15 Dec  4 16:07 appdata -> ../../mmcblk0p8      ( /srv )


lsblk

NAME         MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT

mtdblock0     31:0    0   64K  1 disk

mtdblock1     31:1    0  960K  0 disk

mmcblk0      179:0    0 14.7G  0 disk

├─mmcblk0p1  179:1    0  512K  0 part

├─mmcblk0p2  179:2    0  256K  0 part

├─mmcblk0p3  179:3    0  256K  0 part

├─mmcblk0p4  179:4    0   32M  0 part

├─mmcblk0p5  179:5    0   32M  0 part

├─mmcblk0p6  179:6    0    1G  0 part /mnt/.rofs

├─mmcblk0p7  179:7    0    3G  0 part /mnt/.rwfs

└─mmcblk0p8  179:8    0 10.6G  0 part /srv

mmcblk0boot0 179:32   0    4M  1 disk

mmcblk0boot1 179:64   0    4M  1 disk

mmcblk0rpmb  179:96   0    4M  0 disk

mmcblk1      179:128  0 14.4G  0 disk

└─mmcblk1p1  179:129  0 14.4G  0 part /data     ( SDCARD )




