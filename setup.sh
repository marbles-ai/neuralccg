#/bin/bash

# Fail if we reference any unbound environment variables.
# PWG: we infer JAVA_HOME on ubuntu so cannot do this
#set -u
#set -eo pipefail

# Check if external data needs to be downloaded.
resource_url=lil.cs.washington.edu/resources
data_dir=neuralccg/data
if [ ! -e $data_dir ]
then
    echo "Downloading data from $resource_url"
    mkdir $data_dir

    # Turian et al. (2010) 50-dimensional word embeddings.
    curl -o $data_dir/embeddings.raw $resource_url/embeddings.raw

    # Lewis et al. (2016) supertagging model.
    supertagger=model_tritrain_finetune_long.tgz
    curl -o $supertagger $resource_url/$supertagger
    tar -xzvf $supertagger -C $data_dir
    rm $supertagger

    # Lee et al. (2016) parsing model.
    curl -o $data_dir/llz2016.model.pb $resource_url/llz2016.model.pb
else
    echo "Using cached data from $data_dir"
fi

lib_dir=neuralccg/lib
if [ ! -e $lib_dir ]
then
    echo "Downloading binaries from $resource_url"
    mkdir $lib_dir
    curl -o $lib_dir/libtaggerflow.so $resource_url/libtaggerflow.so
    curl -o $lib_dir/libtaggerflow.jnilib $resource_url/libtaggerflow.jnilib
else
    echo "Using cached binaries from $lib_dir"
fi

rm -f jni/java_home
# Infer JAVA_HOME if we can 
python -mplatform | grep -iq 'ubuntu' \
    && [ "x$JAVA_HOME" == "x" ] \
    && JAVA_HOME=$(update-alternatives --query java | grep 'Value: ' | grep -o '/.*/jre' | sed 's/jre$//g') \
    && echo "Inferred JAVA_HOME=$JAVA_HOME"
# TODO: need location based on os
ln -sf $JAVA_HOME jni/java_home

# Build JNI binaries and move them to the appropriate location.
if python -mplatform | grep -iq 'darwin'; then
	# Bazel issue 2610 - sandboxed rules broken on macos when output_base and workspace have differing case sensitivity
	# I think this is the same issue even though I have a single filesystem - osx defaults to case insensitive
	# https://github.com/bazelbuild/bazel/issues/2610
	bazel build -c opt neuralccg:libdecoder.dylib --strategy=CppCompile=standalone --symlink_prefix=darwin- $*

	rm -f $lib_dir/libdecoder.jnilib
	rm -f $lib_dir/libdecoder.dylib
	cp darwin-bin/neuralccg/libdecoder.dylib $lib_dir/libdecoder.dylib
	cp darwin-bin/neuralccg/libdecoder.dylib $lib_dir/libdecoder.jnilib

	# Now build ubuntu version in a docker container
	docker build -t neuralccg .

	# Need standalong because we mount osx filesystem on /root 
	docker run -v $PWD:/root --rm -it neuralccg /bin/bash -c ./setup.sh --strategy=CppCompile=standalone 
else
	bazel build -c opt neuralccg:libdecoder.so --symlink_prefix=linux- $*

	rm -f $lib_dir/libdecoder.so
	# On linux JNI will load .so so we can package .so for linux and .jnilib for osx
	# in a single jar
	cp linux-bin/neuralccg/libdecoder.so $lib_dir/libdecoder.so
fi

