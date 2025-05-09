# Compiler
CC = g++

# Compiler Flags:
# 	`-Wall`: Enables most warning messages.
# 	`-Wextra`: Enables additional warning messages not covered by `-Wall`.
# 	`-std=c++17`: Specifies the C++ standard version (can be changed to `c++11`, `c++14`, `c++20`, etc.).
# 	`-O2`: Enables a level of optimization for faster code.
CXXFLAGS = -Wall -Wextra -std=c++17 -O2

# Project Structure
LOGGER = can_logger
GENERATOR = can_generator
SRC_DIR = src
BUILD_DIR = build

# Auto-discover source files
# 	The `wildcard` function returns a space-separated list of all files matching the given pattern.
# 	Here, `$(SRC_DIR)/*.cpp` means “all files ending in `.cpp` in the directory specified by `SRC_DIR`.”
SOURCES = $(wildcard $(SRC_DIR)/*.cpp)

# Default target
# 	This line sets up `all` as the default action when you run `make`, 
#	and it triggers the build of your main program or executable as defined 
# 	by `$(BUILD_DIR)/$(LOGGER) $(BUILD_DIR)/$(GENERATOR)`
all: $(BUILD_DIR)/$(LOGGER) $(BUILD_DIR)/$(GENERATOR)

# Logger Target
$(BUILD_DIR)/$(LOGGER): $(BUILD_DIR)/$(LOGGER).o
	$(CC) $(CXXFLAGS) $^ -o $@

# Generator Target
$(BUILD_DIR)/$(GENERATOR): $(BUILD_DIR)/$(GENERATOR).o
	$(CC) $(CXXFLAGS) $^ -o $@

# Compile source files
# 	This rule automates compiling individual source files into object files while maintaining a clean project structure.
# 	`$(BUILD_DIR)/%.o`: Target pattern matching all `.o` files in the build directory.
# 	`$(SRC_DIR)/%.cpp`: Dependency pattern matching `.cpp` files in the source directory with the same base name.
# 	`| $(BUILD_DIR)`: Order-only prerequisite (ensures the directory exists but doesn’t trigger recompilation if modified).
# 	`$<`: Expands to the first prerequisite (`src/file.cpp`).
# 	`$@`: Expands to the target (`build/file.o`).
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp | $(BUILD_DIR)
	$(CC) $(CXXFLAGS) -c $< -o $@

# Create build directory
$(BUILD_DIR):
	mkdir -p $@

# Run Logger
run_logger: all
	./$(BUILD_DIR)/$(LOGGER)

# Run Generator
run_generator: all
	./$(BUILD_DIR)/$(GENERATOR)

# Clean build artifacts
clean:
	rm -rf $(BUILD_DIR)

# A PHONY target in a Makefile is a special kind of target that does not represent a file, 
# but rather a label for a set of commands you want to run
.PHONY: all clean run