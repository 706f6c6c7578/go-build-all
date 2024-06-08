#!/bin/bash

PLATFORMS="aix/ppc64"
PLATFORMS="$PLATFORMS android/386 android/amd64 android/arm android/arm64"
PLATFORMS="$PLATFORMS darwin/amd64 darwin/arm64"
PLATFORMS="$PLATFORMS dragonfly/amd64"
PLATFORMS="$PLATFORMS freebsd/386 freebsd/amd64 freebsd/arm freebsd/arm64 freebsd/riscv64"
PLATFORMS="$PLATFORMS illumos/amd64"
PLATFORMS="$PLATFORMS ios/amd64 ios/arm64"
PLATFORMS="$PLATFORMS js/wasm"
PLATFORMS="$PLATFORMS linux/386 linux/amd64 linux/arm linux/arm64 linux/loong64 linux/mips linux/mips64 linux/mips64le linux/mipsle linux/ppc64 linux/ppc64le linux/riscv64 linux/s390x"
PLATFORMS="$PLATFORMS netbsd/386 netbsd/amd64 netbsd/arm netbsd/arm64"
PLATFORMS="$PLATFORMS openbsd/386 openbsd/amd64 openbsd/arm openbsd/arm64"
PLATFORMS="$PLATFORMS plan9/386 plan9/amd64 plan9/arm"
PLATFORMS="$PLATFORMS solaris/amd64"
PLATFORMS="$PLATFORMS wasip1/wasm"
PLATFORMS="$PLATFORMS windows/386 windows/amd64 windows/arm windows/arm64"

SCRIPT_NAME=`basename "$0"`
FAILURES=""
SOURCE_FILE=`echo $@ | sed 's/\.go//'`
CURRENT_DIRECTORY=${PWD##*/}
OUTPUT=${SOURCE_FILE:-$CURRENT_DIRECTORY}

for PLATFORM in $PLATFORMS; do
  GOOS=${PLATFORM%/*}
  GOARCH=${PLATFORM#*/}
  BIN_FILENAME="${OUTPUT}-${GOOS}-${GOARCH}"
  if [[ "${GOOS}" == "windows" ]]; then BIN_FILENAME="${BIN_FILENAME}.exe"; fi
  CMD="GOOS=${GOOS} GOARCH=${GOARCH} go build -ldflags \"-s -w\" -o ${BIN_FILENAME} $@"
  echo "${CMD}"
  eval $CMD || FAILURES="${FAILURES} ${PLATFORM}"
done

if [[ "${FAILURES}" != "" ]]; then
  echo ""
  echo "${SCRIPT_NAME} failed on: ${FAILURES}"
fi
