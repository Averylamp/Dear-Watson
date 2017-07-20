#!/bin/bash

zip -r archive.zip *
wsk action update keywords --kind nodejs:6 --web true archive.zip
