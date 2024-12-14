#!/bin/bash
# Inside the container, copy the  rdkafka files from where they got installed to where they 
# reside on cmp06. This is an attempt to make the rdkafka files findable by cmake. It is
# also a very ugly and hacky way to do things and so must die very soon.

mkdir -p /usr/include/librdkafka
cp /usr/local/include/librdkafka/* /usr/include/librdkafka

cd /usr/lib64
cp /usr/local/lib/librdkafka++.so.1 .
cp /usr/local/lib/librdkafka.so.1 .
ln -s librdkafka++.so.1 librdkafka++.so
ln -s librdkafka.so.1 librdkafka.so

cd /usr/lib64/pkgconfig 
cp /usr/local/lib/pkgconfig/rdkafka.pc .
cp /usr/local/lib/pkgconfig/rdkafka-static.pc .
cp /usr/local/lib/pkgconfig/rdkafka++.pc .
cp /usr/local/lib/pkgconfig/rdkafka++-static.pc .


cd /usr/lib
ln -s /usr/local/lib/librdkafka.so.1 librdkafka.so
ln -s /usr/local/lib/librdkafka.so.1 librdkafka.so.1


