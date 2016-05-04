# How to get your MATLAB work done on NeSI's Pan cluster

1.  Prerequisites: Work through the companion document [OtagoPanInstructions](https://rawgit.com/dannybaillie/NeSI/master/OtagoPanInstructions.html) first.
2.  Type `nano simplefunction.m` and Copy and Paste the following (it makes a random matrix and displays the result of a calculation), write out and exit:

    ```

    function simplefunction(n)
    n = str2double(n);
    a = rand(n);
    save simpleMatlab a
    2^10

    ```

3.  Type `nano simpleMatlab.sl` and Copy and Paste the following (you need to replace `projectIDhere` with your project ID from [OtagoPanInstructions](https://rawgit.com/dannybaillie/NeSI/master/OtagoPanInstructions.html)), write out and exit:

    ```

    #!/bin/bash
    #SBATCH -J yourjobName
    #SBATCH -A projectIDhere
    #SBATCH --time=1:00:00
    #SBATCH --mem-per-cpu=2048
    #SBATCH --output=simpleMatlabout.txt
    #SBATCH --error=simpleMatlaberr.txt
    module load MATLAB/2015b
    srun matlab -nodesktop -nosplash -nodisplay -nojvm -r 'simplefunction 20'

    ```

4.  Submit the Slurm script you created in step 2 by typing: `sbatch simpleMatlab.sl`.
5.  When your job is finished, you should find three new files:
    *   `simpleMatlab.mat`: a MATLAB file with a 20 by 20 random matrix in it
    *   `simpleMatlabout.txt`: including the text "1024" from calculating 2^10
    *   `simpleMatlaberr.txt`: empty file
6.  You copy the file `simpleMatlab.mat` to your local machine (see [OtagoPanInstructions](https://rawgit.com/dannybaillie/NeSI/master/OtagoPanInstructions.html)) or look at it on the build node using:

    ```
    ssh build-sb 
    module load MATLAB/2015b
    matlab
    load simpleMatlab
    disp(a)

    ```

7.  Changing your code to work on Pan
    *   Inputs: The code you want to run will be a MATLAB script or function. If it is a script then it has no direct inputs (perhaps it will load a .mat file, or all parameters will be set in the script). If it is a function then inputs will be received by MATLAB as text strings. If you need numeric inputs, you'll need to use e.g. `str2double` (as we did in step 2 above).
    *   Outputs: It is not useful for your function to return explicit outputs: either use the text output (what you normally see on the screen which goes into the file you specify with `#SBATCH --output=`) or (much more likely) save results, e.g. to a `.mat` file (as we did in step 1).
    *   To use more than one core, add the following to your `.sl` script (change the 8 to the number of CPUs your code can use):

        ```

        #SBATCH --cpus-per-task=8
        #SBATCH --ntasks=1

        ```
