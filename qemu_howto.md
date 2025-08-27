```bash
qemu-system-aarch64 \
  -M arm-generic-fdt \
  -serial mon:stdio \
  -display none \
  \
  -device loader,file=pmufw.elf,cpu-num=0 \
  -device loader,file=zynqmp_fsbl.elf,cpu-num=0 \
  -device loader,file=app.elf,cpu-num=0
```
