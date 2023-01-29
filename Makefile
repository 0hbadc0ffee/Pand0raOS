ASM=nasm
BUILD_DIR=build
SRC_PATH=src

.PHONY: build bootloader kernel clean floppy_image


# bootloader
bootloader: $(BUILD_DIR)/bootloader.bin
$(BUILD_DIR)/bootloader.bin: build
	$(ASM) -f bin $(SRC_PATH)/bootloader/bootloader.asm -o $(BUILD_DIR)/bootloader.bin


# build
build:
	mkdir -p $(BUILD_DIR)

clean:
	rm -rf $(BUILD_DIR)/*