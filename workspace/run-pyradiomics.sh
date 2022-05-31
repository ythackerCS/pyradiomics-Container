#!/bin/bash -e

if [ $# -eq 0 ]; then
    echo "Generate CSV output from nifti scan and mask files."
    echo "No arguments provided"
	echo "run-basic.sh scan_folder mask_folder params_file output_folder scan_label other_pyradiomics_options"
    exit 1
fi

die() {
    echo "@" 2>&1
    exit 1
}

scan_folder="$1"
shift
mask_folder="$1"
shift
params="$1"
shift
output="$1"
shift
scan_label="$1"
shift
options="$1"

echo "Scan folder: ${scan_folder}"
echo "Mask folder: ${mask_folder}"
echo "Params file: ${params}"
echo "Output dir: ${output}"
echo "Scan LABEL: ${scan_label}"

if [[ $mask = *" "* ]]
then
	die "Mask name: \"${mask}\" may not contain spaces."
fi;


# Begin constructing CSV batch file
scan_matcher="*.nii"
mask_roi_matcher="*.nii"
batch_file="${output}/batch.csv"
echo "Image,Mask" > ${batch_file}
for scan in ${scan_folder}/${scan_matcher}; do
	for roi in ${mask_folder}/${mask_roi_matcher}; do
		echo  "Added: ${scan},${roi} to batch processing list."
		echo  "${scan},${roi}" >> ${batch_file}
	done
done


echo
echo "Running pyradiomics"

echo "pyradiomics ${batch_file} --param ${params} --out ${output}/${scan_label}-pyradiomics.csv --format-path basename --format csv ${options}"
pyradiomics ${batch_file} --param ${params} --out ${output}/${scan_label}-pyradiomics.csv --format-path basename --format csv ${options} || die "pyradiomics failed"

