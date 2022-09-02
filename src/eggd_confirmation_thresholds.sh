#!/bin/bash

# Basic execution pattern: Your app will run on a single machine from
# beginning to end.
#
# Your job's input variables (if any) will be loaded as environment
# variables before this script runs.  Any array inputs will be loaded
# as bash arrays.
#
# Any code outside of main() (or any entry point you may add) is
# ALWAYS executed, followed by running the entry point itself.
#
# See https://documentation.dnanexus.com/developer for tutorials on how
# to modify this file.

set -exo pipefail

main() {

    echo "Value of happy_vcf: '$happy_vcf'"
    echo "Value of sentieon_vcf: '$sentieon_vcf'"
    echo "Value of metric_list: '$metric_list'"

    pip install -r requirements.txt

    # The following line(s) use the dx command-line tool to download your file
    # inputs to the local file system using variable names for the filenames. To
    # recover the original filenames, you can use the output of "dx describe
    # "$variable" --name".

    dx download "$happy_vcf"

    dx download "$sentieon_vcf"

    # Run confirmation_thresholds script

    python3 FPTP.py --happy $happy_vcf_name --query $sentieon_vcf_name --metrics $metric_list

    # The following line(s) use the dx command-line tool to upload your file
    # outputs after you have created them on the local file system.  It assumes
    # that you have used the output field name for the filename for each output,
    # but you can change that behavior to suit your needs.  Run "dx upload -h"
    # to see more options to set metadata.

    html_report=$(find . -name "*.html")

    html_report=$(dx upload $html_report --brief)

    # The following line(s) use the utility dx-jobutil-add-output to format and
    # add output variables to your job's output as appropriate for the output
    # class.  Run "dx-jobutil-add-output -h" for more information on what it
    # does.

    dx-jobutil-add-output html_report "$html_report" --class=file
}
