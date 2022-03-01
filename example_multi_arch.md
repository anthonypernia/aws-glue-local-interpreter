# AMD64
$ docker build -t anthonyperniah/aws-glue-local-interpreter:manifest-amd64 --build-arg ARCH=amd64/ .
$ docker push anthonyperniah/aws-glue-local-interpreter:manifest-amd64

# ARM32V7
$ docker build -t anthonyperniah/aws-glue-local-interpreter:manifest-arm32v7 --build-arg ARCH=arm32v7/ .
$ docker push anthonyperniah/aws-glue-local-interpreter:manifest-arm32v7

# ARM64V8
$ docker build -t anthonyperniah/aws-glue-local-interpreter:manifest-arm64v8 --build-arg ARCH=arm64v8/ .
$ docker push anthonyperniah/aws-glue-local-interpreter:manifest-arm64v8




docker manifest create \
anthonyperniah/aws-glue-local-interpreter:manifest-latest \
--amend anthonyperniah/aws-glue-local-interpreter:manifest-amd64 \
--amend anthonyperniah/aws-glue-local-interpreter:manifest-arm32v7 \
--amend anthonyperniah/aws-glue-local-interpreter:manifest-arm64v8


docker manifest push anthonyperniah/aws-glue-local-interpreter:manifest-latest