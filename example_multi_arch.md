### To build images in architectures: AMD64 (most-common)
```
$ docker build -t anthonyperniah/aws-glue-local-interpreter:manifest-amd64 --build-arg ARCH=amd64/ .
```
```
$ docker push anthonyperniah/aws-glue-local-interpreter:manifest-amd64
```
#### To build images in architectures: ARM64V8 (For example: Raspberry-pi)
```
$ docker build -t anthonyperniah/aws-glue-local-interpreter:arm64v8 --build-arg ARCH=arm64v8/ .
````
```
$ docker push anthonyperniah/aws-glue-local-interpreter:arm64v8
```
####Create manifest with both tags
```
$ docker manifest create \
anthonyperniah/aws-glue-local-interpreter:manifest-latest \
--amend anthonyperniah/aws-glue-local-interpreter:amd64 \
--amend anthonyperniah/aws-glue-local-interpreter:arm64v8
```
####Upload manifest
```
docker manifest push anthonyperniah/aws-glue-local-interpreter:manifest-latest
```