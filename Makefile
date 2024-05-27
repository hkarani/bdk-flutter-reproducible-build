.PHONY: all clean

all: build.sh
		./build.sh  # Indentation with a tab character

clean:
		rm -rf lib-* your_project/build.sh

