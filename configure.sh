#!/usr/bin/env bash

set -e
set -o pipefail
set -u

LLVM_VERSION=10.0.0
LLVM_HASH=70a7d5ed3bb16a5b5310ea4bfe95a74894022a43abb96d28ef8e30ab1f41d47a
LLVM_CONFIG=${LLVM_CONFIG:-llvm-config}

command -v "${LLVM_CONFIG}" >/dev/null 2>&1 || {
    PREFIX="deps/clang-${LLVM_VERSION}"
    if [ ! -f "${PREFIX}/bin/llvm-config" ]; then
        mkdir -p "deps"
        FILE="deps/clang-${LLVM_VERSION}.tar.xz"
        if [ ! -f "${FILE}" ]; then
            URL="https://github.com/llvm/llvm-project/releases/download/llvmorg-${LLVM_VERSION}/clang+llvm-${LLVM_VERSION}-x86_64-apple-darwin.tar.xz"
            echo "Downloading ${URL}..."
            curl --retry 3 -# -S -L "${URL}" -o "${FILE}.tmp" && mv "${FILE}.tmp" "${FILE}"
        fi
        echo -n "Checking file... "
        echo "${LLVM_HASH}  ${FILE}" | shasum -a 512256 -c
        rm -rf "${PREFIX}"
        mkdir -p "${PREFIX}"
        echo -n "Unpacking archive... "
        tar xf "${FILE}" -C "${PREFIX}" --strip-components 1
        echo "done."
    fi
    LLVM_CONFIG="${PREFIX}/bin/llvm-config"
}

PREFIX="$("${LLVM_CONFIG}" --prefix)"
case "${PREFIX}" in
  *\ *) (>&2 echo "Error: Path to LLVM may not contain spaces: '${PREFIX}'"); exit 1 ;;
esac

echo "// Do not modify this file. Instead, rerun ./configure" > config.xcconfig
echo "LLVM_LIBDIR=$(${LLVM_CONFIG} --libdir)" >> config.xcconfig
echo "LLVM_INCLUDE_DIR=$(${LLVM_CONFIG} --includedir)" >> config.xcconfig
echo "LLVM_CXXFLAGS=$(${LLVM_CONFIG} --cxxflags)" >> config.xcconfig

echo "Wrote config.xcconfig."

open XcodeClangFormat.xcodeproj
