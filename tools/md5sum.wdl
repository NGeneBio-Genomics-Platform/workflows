## Description:
##
## This WDL tool wraps the md5sum tool from the GNU core 
## utilities (https://github.com/coreutils/coreutils).
## md5sum is a utility for generating and verifying MD5
## hashes.  

task print_version {
    command {
        md5sum --version
    }

    runtime {
        docker: 'stjudecloud/bioinformatics-base:bleeding-edge'
    }

    output {
        String out = read_string(stdout())
    }
}
task compute_checksum {
    File infile

    Float infile_size = size(infile, "GiB")
    Int disk_size = ceil((infile_size * 2) + 10)

    command {
        md5sum ${infile} > stdout.txt
    }

    runtime {
        disk: disk_size + " GB"
        docker: 'stjudecloud/bioinformatics-base:bleeding-edge'
    }

    output {
        String out = read_string("stdout.txt")
    }
}
task check_checksum {
    File infile
  
    Float infile_size = size(infile, "GiB")
    Int disk_size = ceil((infile_size * 2) + 10)

    command { 
        md5sum -c ${infile} > stdout.txt
    } 

    runtime {
        disk: disk_size + " GB"
        docker: 'stjudecloud/bioinformatics-base:bleeding-edge'
    }

    output {
        String out = read_string("stdout.txt")
    }
}
