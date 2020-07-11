# thumbr
This is a simple container for use with CI/CD housing `imagemagick` that's used
as part of `thumbr.sh` to, well, _thumbnail_-ify images. The intended use is for
mounting a directory of images, with right user permissions, to be
processed. Part of this creates a new directory from the directory it was called
from.

## Example
The following directory structure:
```
/home/user/img/
├── import
│   └── 2019-02-18
│       └── DSC04706.jpg
├── my_photo-1.jpg
└── my_photo-2.jpg
```

Passed to `thumbr` with **default options** would become:
```
/home/user/img/
├── w_500
│   ├── import
│   │   └── 2019-02-18
│   │       └── DSC04706.jpg
│   ├── my_photo-1.jpg
│   └── my_photo-2.jpg
├── import
│   └── 2019-02-18
│       └── DSC04706.jpg
├── my_photo-1.jpg
└── my_photo-2.jpg
```

# Usage
The directory of images that's desired to be `thumbr`'d should be mounted in
`/src`, with the proper permissions such as:
```
docker run -it --rm --user $(id -u $USER):$(id -g $USER) -v path/to/img/dir:/src bdebyl/thumbr .
```

## Help
Simply run the container with the `-h` command:
```
docker run -it --rm bdebyl/thumbr -h
```
