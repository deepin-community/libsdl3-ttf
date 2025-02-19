#!/bin/bash
# Adapted from upstream's build-shaders.sh to avoid spirvcross dependency

set -e

make-header() {
    xxd -i "$1" | sed \
        -e 's/^unsigned /const unsigned /g' \
        -e 's,^const,static const,' \
        > "$1.h"
}

# Requires shadercross CLI installed from SDL_shadercross
for filename in *.vert.hlsl; do
    if [ -f "$filename" ]; then
        glslangValidator -e main -o "${filename/.hlsl/.spv}" -V -D "$filename"
        make-header "${filename/.hlsl/.spv}"

        # We don't use these on Linux, they just need to exist
        : > "${filename/.hlsl/.msl}"
        make-header "${filename/.hlsl/.msl}"
        : > "${filename/.hlsl/.dxil}"
        make-header "${filename/.hlsl/.dxil}"
    fi
done

for filename in *.frag.hlsl; do
    if [ -f "$filename" ]; then
        glslangValidator -e main -o "${filename/.hlsl/.spv}" -V -D "$filename"
        make-header "${filename/.hlsl/.spv}"

        # We don't use these on Linux, they just need to exist
        : > "${filename/.hlsl/.msl}"
        make-header "${filename/.hlsl/.msl}"
        : > "${filename/.hlsl/.dxil}"
        make-header "${filename/.hlsl/.dxil}"
    fi
done
