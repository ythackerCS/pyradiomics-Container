# Pyradiomics - DICOM to CSV

This Docker image and associated XNAT command are designed to compute radiomics features using the Pyradiomics package.

## I/O

### Input files are collected from XNAT via Container Service plugin 

- DICOM Image directory
- RT Struct file
- Pyradiomics params yaml file stored as a Project resource with the label 'PYRADIOMICS_PARAMS'

### Intermediate files are generated using setup containers (dcm2niix & plastimatch)
- Image NIFTI (via dcm2niix)
- Mask NIFTI (via plastimatch)

* Radiomics features are saved back to XNAT as a CSV file 
- pyradiomics.csv


## Run Script

The xnat/pyradiomics command calls the run-pyradiomics shell script

## Docker CLI

* NIFTI Image - dcm2niix
`docker run --rm -v $PWD/sample/M00094680_20170510135855/6/DICOM/:/input:ro -v $PWD/sample/output/image:/output xnat/dcm2niix:dev dcm2niix -o /output /input`

* NIFTI Mask - plastimatch
`docker run --rm -v $PWD/sample/M00094680_20170510135855/AIM_20200707_124424/RTSTRUCT/:/input:ro -v $PWD/sample/output/mask:/output xnat/plastimatch:dev \
	plastimatch convert --input /input/AIM_20200707_124424.dcm --output-prefix /output --prefix-format nii --output-ss-list /output/RSTT.txt`

* Pyradiomics
`docker run --rm -v $PWD/sample/output/image:/input/scan:ro -v /tmp/MASK:/input/mask -v $PWD/workspace/:/params:ro -v $PWD/sample/output:/output xnat/pyradiomics:0.2.0 \
run-pyradiomics.sh /input/scan/ /input/mask/ /params/exampleCT.yaml /output S1234_S5678 '--verbosity 3'`





## Pyradiomics

### Sample parameters

Pyradiomics requires a 'parameters' file to specify radiomics features to be computed. Sample files can be found at: https://github.com/AIM-Harvard/pyradiomics/tree/master/examples/exampleSettings


### Usage
pyradiomics usage

usage: pyradiomics image|batch [mask] [Options]

optional arguments:
  -h, --help            show this help message and exit
  --label N, -l N       (DEPRECATED) Value of label in mask to use for
                        feature extraction.
  --version             Print version and exit

Input:
  Input files and arguments defining the extraction:
  - image and mask files (single mode) or CSV-file specifying them (batch mode)
  - Parameter file (.yml/.yaml or .json)
  - Overrides for customization type 3 ("settings")
  - Multi-threaded batch processing

  {Image,Batch}FILE     Image file (single mode) or CSV batch file (batch mode)
  MaskFILE              Mask file identifying the ROI in the Image.
                        Only required when in single mode, ignored otherwise.
  --param FILE, -p FILE
                        Parameter file containing the settings to be used in extraction
  --setting "SETTING_NAME:VALUE", -s "SETTING_NAME:VALUE"
                        Additional parameters which will override those in the
                        parameter file and/or the default settings. Multiple
                        settings possible. N.B. Only works for customization
                        type 3 ("setting").
  --jobs N, -j N        (Batch mode only) Specifies the number of threads to use for
                        parallel processing. This is applied at the case level;
                        i.e. 1 thread per case. Actual number of workers used is
                        min(cases, jobs).
  --validate            If specified, check if input is valid and check if file locations point to exisiting files

Output:
  Arguments controlling output redirection and the formatting of calculated results.

  --out FILE, -o FILE   File to append output to.
  --out-dir OUT_DIR, -od OUT_DIR
                        Directory to store output. If specified in segment mode, this writes csv output for each processed case. In voxel mode, this directory is used to store the featuremaps. If not specified in voxel mode, the current working directory is used instead.
  --mode {segment,voxel}, -m {segment,voxel}
                        Extraction mode for PyRadiomics.
  --skip-nans           Add this argument to skip returning features that have an
                        invalid result (NaN)
  --format {csv,json,txt}, -f {csv,json,txt}
                        Format for the output.
                        "txt" (Default): one feature per line in format "case-N_name:value"
                        "json": Features are written in a JSON format dictionary
                        (1 dictionary per case, 1 case per line) "{name:value}"
                        "csv": one row of feature names, followed by one row of
                        feature values per case.
  --format-path {absolute,relative,basename}
                        Controls input image and mask path formatting in the output.
                        "absolute" (Default): Absolute file paths.
                        "relative": File paths relative to current working directory.
                        "basename": Only stores filename.
  --unix-path, -up      If specified, ensures that all paths in the output
                        use unix-style path separators ("/").

Logging:
  Controls the (amount of) logging output to the console and the (optional) log-file.

  --logging-level LEVEL
                        Set capture level for logging
  --log-file FILE       File to append logger output to
  --verbosity [{1,2,3,4,5}], -v [{1,2,3,4,5}]
                        Regulate output to stderr. By default [3], level
                        WARNING and up are printed. By specifying this
                        argument without a value, level INFO [4] is assumed.
                        A higher value results in more verbose output.



