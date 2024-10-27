
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
docker build --platform linux/amd64 -t lilypond-layer .
 ```

 Run interactive & mount .ly file
 ```
docker run -v /Users/yifanguo/Downloads/output.ly:/opt/lambda/layer/bin/output.ly --platform linux/amd64 -it lilypond-layer /bin/bash
 ```

 Execute & generate pdf
 ```
/opt/bin/lilypond -o /tmp/output /output/output.ly
 ```
(suffix will be added) by lilypond 

 Expected output
 ```
 GNU LilyPond 2.24.4 (running Guile 2.2)
Processing `output.ly'
Parsing...
Interpreting music...[8][16][24][32][40][48][56][64][72][80][88][96][104][112][120][128][136][144]
Preprocessing graphical objects...
Finding the ideal number of pages...
Fitting music on 1 or 2 pages...
Drawing systems...
Converting to `output.pdf'...
Success: compilation successfully completed
```

To fix the dreaded `Fontconfig error: No writeable cache directories` error, update the home directory to `/tmp`. On AWS Lambda, the file system is read-only except for the `/tmp` directory. 
- https://stackoverflow.com/questions/73394593/aws-lambda-function-returns-errormessage-errno-30-read-only-file-system
- https://stackoverflow.com/questions/77331227/fontconfig-error-no-writable-cache-directories