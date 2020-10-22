# docker-4dn-insulation-scores-and-boundaries-caller

This repo contains the source files for a docker image stored in docker-4dn-insulation-scores-and-boundaries-caller.
## Table of contents
* [Cloning the repo](#cloning-the-repo)
* [Tool specifications](#tool-specifications)
* [Building docker image](#building-docker-image)
* [Benchmarking tools](#benchmarking-tools)
* [Sample data](#sample-data)
* [Tool wrappers](#tool-wrappers)

## Cloning the repo
```
git clone https://github.com/4dn-dcic/docker-4dn-insulation-scores-and-boundaries-caller
cd docker-4dn-insulation-scores-and-boundaries-caller
```

## Tool specifications
Major software tools used inside the docker container are downloaded by the script `downloads.sh`. This script also creates a symlink to a version-independent folder for each software tool. In order to build an updated docker image with a new version of the tools, ideally only `downloads.sh` should be modified, but not `Dockerfile`, unless the new tool requires a specific APT tool that need to be downloaded. 
The `downloads.sh` file also contains comment lines that specifies the name and version of individual software tools.

## Building docker image
4dn-insulation-scores-and-boundaries-caller
You need docker daemon to rebuild the docker image. If you want to push it to a different docker repo, replace 4dndcic/4dn-insulation-scores-and-boundaries-caller with your desired docker repo name. You need permission to push to 4dndcic/4dn-insulation-scores-and-boundaries-caller.
```
docker build -t 4dndcic/4dn-insulation-scores-and-boundaries-caller .
docker push 4dndcic/4dn-insulation-scores-and-boundaries-caller
```
You can skip this if you want to use an already built image on docker hub (image name 4dndcic/4dn-insulation-scores-and-boundaries-caller). The command 'docker run' (below) automatically pulls the image from docker hub.


## Benchmarking tools
To obtain run time and max mem stats, use `usr/bin/time` that is installed in the docker container. For example, run the following to benchmark `du`.
```
docker run 4dndcic/4dn-insulator-score-caller /usr/bin/time du 2> log
cat log
```
The output looks as follows:
```
0.02user 0.82system 0:00.87elapsed 96%CPU (0avgtext+0avgdata 2024maxresident)k
0inputs+0outputs (0major+103minor)pagefaults 0swaps
```
The benchmarking result goes to STDERR, which can be collected by a file by redirecting with `2>`.
Maxmem is 2024KB in this case ('maxresident'). Run time is 0.87 second. ('elapsed')


## Sample data
Sample data files that can be used for testing the tools are included in the `sample_data` folder. These data are not included in the docker image.

## Tool wrappers

Tool wrappers are under the `scripts` directory and follow naming conventions `run-xx.sh`. These wrappers are copied to the docker image at built time and may be used as a single step in a workflow.

```
# default
docker run 4dndcic/4dn-insulation-scores-and-boundaries-caller

# specific run command
docker run 4dndcic/4dn-insulation-scores-and-boundaries-caller <run-xx.sh> <arg1> <arg2> ...

# may need -v option to mount data file/folder if they are used as arguments.
docker run -v /data1/:/d1/:rw -v /data2/:/d2/:rw 4dndcic/4dn-insulation-scores-and-boundaries-caller <run-xx.sh> /d1/file1 /d2/file2 ...
```

### run-insulation-scores-and-boundaries-caller.sh
This calls the 'get_insulation_scores_and_boundaries.py' file which gets the diamond insulation scores and boundaries from mcool files produced by Hi-C data
and outputs them in bigwig and bed format respectively.
* Input: a mcool file
* Output: a bigwig file with insulation scores and a bed file with boundaries

#### Usage
Runs the following in the container
```
run-insulation-scores-and-boundaries-callerr.sh <mcoolfile> <outdir> <filename> --binsize --windowsize --bweak --bstrong --cutoff --pixels_frac
# mcool file: input mcool
# outdir: output directory
# binsize: the size of the bins
# windowsize: the size of the sliding diamond window
# bweak: the threshold for defining weak boundaries
# bstrong: the threshold for defining strong boundaries
# cutoff: minimal distance allowed to a bad bin. Do not calculate insulation scores for bad bins closer to that distance
# pixels_frac: The minimal fraction of valid pixels in a diamond to be used in boundary picking and prominence calculation
```
