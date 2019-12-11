#!/bin/sh

cp funcoin-proto/blockchain.proto Blockchain.proto
sed -i '' '2i\
option swift_prefix="Funcoin";' Blockchain.proto
protoc --swift_opt=FileNaming=DropPath --swift_out=./Source/Proto Blockchain.proto
rm Blockchain.proto
