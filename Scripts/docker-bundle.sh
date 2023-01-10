docker run \
    --rm \
    --volume "$(pwd)/:/src" \
    --workdir "/src/" \
    swift:5.7.1-amazonlinux2 \
    swift build --product TwilioLambda -c release -Xswiftc -static-stdlib
