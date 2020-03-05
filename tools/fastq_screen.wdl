version 1.0

task build_db {
    input {
        String filename = "fastq-screen-db"
        Int? max_retries = 1
    }

    String tar_filename = filename + ".tar.gz"

    command {
        fastq_screen --get_genomes
        mv FastQ_Screen_Genomes/ ~{filename}/
        tar -czf ~{tar_filename} ~{filename}/
    }
 
    runtime {
        disk: "30 GB"
        docker: "stjudecloud/fastq_screen:1.0.0-alpha"
        maxRetries: max_retries
    }

    output {
        File db = tar_filename
    }

    meta {
        author: "Clay McLeod"
        email: "clay.mcleod@STJUDE.org"
        description: ""
    }

    parameter_meta {}
} 

task fastq_screen {
    input {
        File read1
        File read2
        File db
        String? format = "illumina"
        Int? num_reads = 100000
        Int? max_retries = 1
    }

    String output_basename = basename(read1, ".fastq") + "_screen"
    String db_name = basename(db)

    command {
        cp ~{db} /tmp
        tar -xsf /tmp/~{db_name} -C /tmp/
        fastq_screen --conf /home/fastq_screen.conf --aligner bowtie2 ~{read1} ~{read2}
    }
 
    runtime {
        docker: "stjudecloud/fastq_screen:1.0.0-alpha"
        maxRetries: max_retries
    }

    output {
        Array[File] out_files = glob("~{output_basename}*")
    }
}