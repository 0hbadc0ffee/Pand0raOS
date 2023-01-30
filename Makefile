ASM=nasm
BUILD_DIR=build
SRC_PATH=src

.PHONY: build bootloader kernel clean floppy_image

# floppy image
floppy_image: $(BUILD_DIR)/floppy.img
$(BUILD_DIR)/floppy.img: bootloader kernel
	dd if=/dev/zero of=$(BUILD_DIR)/floppy.img bs=512 count=2880
	mkfs.fat -F 12 $(BUILD_DIR)/floppy.img -n "SYSTEM"
	dd if=$(BUILD_DIR)/bootloader.bin of=$(BUILD_DIR)/floppy.img conv=notrunc
	mcopy -i $(BUILD_DIR)/floppy.img $(BUILD_DIR)/kernel.bin "::kernel.bin"

# bootloader
bootloader: $(BUILD_DIR)/bootloader.bin
$(BUILD_DIR)/bootloader.bin: build
	$(ASM) -f bin $(SRC_PATH)/bootloader/bootloader.asm -o $(BUILD_DIR)/bootloader.bin

# kernel
kernel: $(BUILD_DIR)/kernel.bin
$(BUILD_DIR)/kernel.bin: build
	$(ASM) -f bin $(SRC_PATH)/kernel/kernel.asm -o $(BUILD_DIR)/kernel.bin


# build
build:
	mkdir -p $(BUILD_DIR)

clean:
	rm -rf $(BUILD_DIR)/*