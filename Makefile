# Compiler
CC = g++

# Compiler Flags:
# 	`-Wall`: Enables most warning messages.
# 	`-Wextra`: Enables additional warning messages not covered by `-Wall`.
# 	`-std=c++17`: Specifies the C++ standard version (can be changed to `c++11`, `c++14`, `c++20`, etc.).
# 	`-O2`: Enables a level of optimization for faster code.
CXXFLAGS = -Wall -Wextra -std=c++17 -O2

# Project Structure
TARGET = can_logger
SRC_DIR = src
BUILD_DIR = build

# Auto-discover source files
# 	The `wildcard` function returns a space-separated list of all files matching the given pattern.
# 	Here, `$(SRC_DIR)/*.cpp` means “all files ending in `.cpp` in the directory specified by `SRC_DIR`.”
SOURCES = $(wildcard $(SRC_DIR)/*.cpp)
# 	The `patsubst` function stands for “pattern substitution.” It replaces text in a list of strings according to a pattern.
# 	The pattern here says: take each file in `$(SOURCES)` that matches `$(SRC_DIR)/%.cpp` (e.g., `src/main.cpp`) 
# 		and convert it to `$(BUILD_DIR)/%.o` (e.g., `build/main.o`).
OBJECTS = $(patsubst $(SRC_DIR)/%.cpp,$(BUILD_DIR)/%.o,$(SOURCES))

# Default target
# 	This line sets up `all` as the default action when you run `make`, 
#	and it triggers the build of your main program or executable as defined by `$(BUILD_DIR)/$(TARGET)`
all: $(BUILD_DIR)/$(TARGET)

# Link executable
# 	This rule tells `make` how to link all the object files together to produce the final executable. 
# 	If any object file changes, `make` will re-run this command to update the executable
# 	`$(CC)` is the compiler (e.g., `g++`).
# 	`$(CXXFLAGS)` are the compiler flags (e.g., `-Wall -Wextra -std=c++17 -O2`).
# 	`$^` is an automatic variable that expands to all the dependencies (the object files).
# 	`-o $@` tells the compiler to name the output file as the target (`$@` expands to `$(BUILD_DIR)/$(TARGET)`).
$(BUILD_DIR)/$(TARGET): $(OBJECTS)
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

# Run the program
run: all
	./$(BUILD_DIR)/$(TARGET)

# Clean build artifacts
clean:
	rm -rf $(BUILD_DIR)

# A PHONY target in a Makefile is a special kind of target that does not represent a file, 
# but rather a label for a set of commands you want to run
.PHONY: all clean run