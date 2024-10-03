
Build Your Container:
```
docker build -t lilypond-layer .
```

Run Your Container:

```
docker run --name my-container -v $(pwd):/output lilypond-layer
```


Build & Run
```
 docker build -t lilypond-layer . ; docker run --rm -v $(pwd):/output2 lilypond-layer
 ```

 Run interactive & mount .ly file
 ```
docker run -v /Users/yifanguo/Downloads/output.ly:/opt/lambda/layer/bin/output.ly -it lilypond-layer /bin/bash
 ```

 Execute & generate pdf
 ```
 cd /opt/lambda/layer/bin/
 ```