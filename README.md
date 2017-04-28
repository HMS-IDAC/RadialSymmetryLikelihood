RadialSymmetryLikelihood is a set of Matlab routines
to compute a coefficient of radial symmetry,
i.e., amount of radial symmetry, in grayscale images.


### Dependencies


This software requires the Bioformats MATLAB Toolbox.

	1. Download it from http://downloads.openmicroscopy.org/bio-formats/5.3.4/

	2. Place the toolbox in the same folder where this software is located.

	3. Add the Bioformats MATLAB Toolbox to Matlab's path.
	For example, if the Bioformats folder is 'bfmatlab', add it to the path by executing...

	    addpath(genpath('bfmatlab'))

	...in Matlab's command line.


### Usage


The main function is radialSymmetryLikelihood.m

There are two main scripts that can be execute from Matlab's prompt:


runSingleRadialSymmetryLikelihood

    computes radialSymmetryLikelihood on a single image file
    outputs:
    1. a .tif image of the accumulator space will be saved
       in the same folder of the input, with '_AccSpace' added to the name
    2. two values will be displayed on Matlab's prompt (command line):
       > radial symmery likelihood
       > row and column of global maximum of the accumulator space
    
    Any of the images in the provided folder SampleImages can be used to test this routine.


runMultipleRadialSymmetryLikelihood

    computes radialSymmetryLikelihood on all images in a folder;
    folder should contain only images to be analized, and nothing else,
        except for the files generated (_AccSpace images and Results.csv)
    that is, the program will not read _AccSpace images and Results.csv,
        but will try reading everything else in the folder
    outputs:
    1. for every image in 'folderpath', a .tif image with the accumulator
       space will be saved in the folder, with '_AccSpace' added to the name
    2. a table with resuls will be saved in Results.csv;
       Columns are: name of file, radial symmetry likelihood, row of global maximum,
       column of global maximum

    The provided folder SampleImages can be used to test this routine.