#!/bin/bash

git clone https://github.com/oneapi-src/oneAPI-samples.git
cd oneAPI-samples
git apply ../../patch/oneapi-samples-enable-correctness-check.patch
