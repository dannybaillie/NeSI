# How to get your work done on NeSI's Pan cluster

## For: Anyone with a University of Otago username and password (as you would use for the library).

1.  Prerequisites: You will need to use the terminal (aka the shell, command-line, the application "Terminal" on a Mac, or MobaXTerm in Windows). You press "return" or "enter" after each command. Read what it says on the screen. Just get started with the following and see how you go no matter what your background. To avoid typos, it is better to Copy and Paste the commands. If you have trouble and think it might be helped by learning about the shell, try the first three topics of [swcarpentry:shell](http://swcarpentry.github.io/shell-novice/) (Introducing the Shell, Files and Directories, Creating Things). If the instructions aren't working for you, I'd like to improve them, so please email me at Otago ([Danny Baillie](mailto:danny.baillie@otago.ac.nz?Subject=PanInstructions)). People at NeSI are keen to help, email them at [support@nesi.org.nz](mailto:support@nesi.org.nz).
2.  Go to [ceres portal](https://web.ceres.auckland.ac.nz/portal).
3.  If you are told you need to log in, do so: this takes you to step 6 below.
4.  Click on "Request an account to get access to the NeSI Auckland cluster".
5.  Choose Federation: "Tuakiri New Zealand Access Federation", Organisation "University of Otago" and click "Select".
6.  Enter your Otago username and password.
7.  OK the information to be sent to NeSI.
8.  Put your details on the application form, including choosing your department from the drop down list and giving a contact phone number.
9.  Wait for an email stating that you have an account. See [How to use ssh keys](https://wiki.auckland.ac.nz/display/CER/How+to+log+in+using+ssh+keys) if you need more help on the next three steps.
10.  Make an ssh key using `ssh-keygen -t rsa -f ~/.ssh/pan_rsa_key` in terminal.
11.  Send a blank email to [eresearch@nesi.org.nz](mailto:eresearch@nesi.org.nz?Subject=Public%20SSH%20key%20for%20user%20your.cluster.username) with "Public SSH key for user your.cluster.username" as the subject (change "your.cluster.username" to your login name). Attach the file `~/.ssh/pan_rsa_key.pub` to the email. This is the public ssh key. NEVER send the private key `pan_rsa_key` (without the `.pub`). On Macs, `.ssh` is a hidden directory. A way to get there is to choose "Go to Folder..." from the "Go" menu in Finder, then type in `~/.ssh`. Then you can drag the file `pan_rsa_key.pub` to your email.
12.  Type `nano ~/.ssh/config`, Copy and Paste the following (but remember to replace `your.cluster.username` with your username), write out and exit:

    ```
        host pan
        HostName login.uoa.nesi.org.nz
        User your.cluster.username # <- REPLACE this with your Pan username
        IdentityFile ~/.ssh/pan_rsa_key
        ServerAliveInterval 120

    ```

    Add to what is already there if the file exists. See [swcarpentry:create](http://swcarpentry.github.io/shell-novice/02-create.html) if you want help with nano.
13.  If you don't know of an existing project you can join, choose "Request a new project" at [ceres portal](https://web.ceres.auckland.ac.nz/portal). Fill in the project title and description (e.g. copy and paste an abstract from one of your relevant papers). Wait for two email confirmations:
14.  Confirmation that the public key has been associated with your account.
15.  Confirmation that your project has been created. This will give you a projectID in it (aka "Project Code"), something like "uoo93837".
16.  You should now be able to login using `ssh pan` in terminal. From now, when in terminal, you need to be aware whether you are "on Pan" or "on your local machine". This will usually be clear from the screen, but you can type in `hostname` to find out. If you are "on Pan" then `hostname` will say something like `login-01.uoa.nesi.org.nz`. If you open a new terminal window it will be "on your local machine". If you type `ssh pan` and it works you will be "on Pan".
17.  On Pan, type `nano simple.sl` and Copy and Paste the following (but remember to change `projectIDhere` to the projectID you got from step 15), write out and exit:

    ```
    #!/bin/bash
    #SBATCH -J testoutput
    #SBATCH -A projectIDhere  # <- REPLACE this with your "Project Code"
    #SBATCH --time=1:00:00
    #SBATCH --mem-per-cpu=2G
    #SBATCH --output=simpleout.txt
    #SBATCH --error=simpleerr.txt
    srun echo test

    ```

18.  Type in `sbatch simple.sl`. If you get an error about the project ID:
    1.  check that you replaced "projectIDhere" with the projectID you got from your confirmation email.
    2.  wait for an hour and try again
    3.  if it takes longer than a few hours, ask for help from [support@nesi.org.nz](mailto:support@nesi.org.nz) (there has been trouble with projectIDs)
19.  When the job is finished you will have two new files:

    `simpleout.txt`: with contents "test"
    `simpleerr.txt`: empty file with zero bytes

20.  Array jobs. On the Pan cluster, type `nano array.sl` and Copy and Paste the following (but remember to change `projectIDhere` to the projectID you got from step 15), write out and exit:

    ```
    #!/bin/bash
    #SBATCH -J arraytest
    #SBATCH -A projectIDhere
    #SBATCH --time=1:00:00
    #SBATCH --mem-per-cpu=1024 
    #SBATCH --cpus-per-task=1
    #SBATCH --output=arrayout_%a.txt
    #SBATCH --error=arrayerr_%a.txt
    #SBATCH --array=1-10
    srun echo test$SLURM_ARRAY_TASK_ID

    ```

21.  Type in `sbatch array.sl`.
22.  When the job is finished you will have 20 new files:

    `arrayout_1.txt` ... `arrayout_10.txt`: with contents "test1" ... "test10"
    `arrayerr_1.txt` ... `arrayerr_10.txt`: empty files with zero bytes

23.  For your own work, replace the last line of the files ending `.sl` with the work you want to do (always preceded by `srun`). If you're using R, see also the separate file [RPanInstructions](https://rawgit.com/dannybaillie/NeSI/master/RPanInstructions.html). You will need to send your code and input data to Pan and bring the results back to your local machine. You can do this on your local machine with:

    To Pan: `scp pathtofiles pan:destinationpath`
    From Pan: `scp pan:pathtofiles destinationpath`

    For improved speed or if you have trouble with stalling, replace `scp` with `rsync --progress -az -e ssh`. Although this works for code, I recommend git (see [swcarpentry:git](http://swcarpentry.github.io/git-novice)). Once you have you repository set up (e.g. for free on [bitbucket](http://www.bitbucket.org) or [github](http://www.github.com)), you workflow would be something like (starting from your local machine):

    ```
    git add .
    git commit -a -m "fixed T=0 overflow bug"
    git push web master
    ssh pan
    git pull web master

    ```

Notes. These pointers are particularly handy for running longer jobs.

You can monitor submitted jobs with the command: `squeue -u your.cluster.username`

The job IDs here (or shown when you submit jobs to the cluster with `sbatch`) can be used in a variety of ways. Replace "JobID" here with the numerical code for your job.

* To cancel running or queued job if you spot an error in one with `scancel JobID`

* To submit another job with a dependancy (it will only run once a prior job has completed). For example 
if we note the Job ID for test.sl, we could submit and array job to run once test.sl has completed:

    ```
    sbatch sbatch --dependency=afterok:JobID array.sl
    ```

You can also add the following lines to your slurm `test.sl` file to get email notifications:
    
    ```
    #SBATCH --mail-type=ALL # other options include BEGIN, END, FAIL (for when the cluster will email you)
    #SBATCH --mail-user=username@domain # <- Your email address here
    ```
    
    
