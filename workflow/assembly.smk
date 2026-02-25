"""
Genome Assembly Rules
"""

rule flye_assembly:
    input:
        f"{OUT}/trimmed/{{sample}}.trimmed.fastq"
    output:
        fasta = f"{OUT}/assembly/{{sample}}/assembly.fasta"
    params:
        outdir = f"{OUT}/assembly/{{sample}}",
        genome_size = config["assembly"]["flye"]["genome_size"],
        extra = config["assembly"]["flye"]["extra"]
    threads: config["assembly"]["flye"]["threads"]
    conda:
        "../environment.yml"
    log:
        f"{OUT}/logs/flye/{{sample}}.log"
    shell:
        """
        flye --nano-raw {input} \
             --out-dir {params.outdir} \
             --threads {threads} 2> {log}
        """

rule megahit_assembly:
    input:
        f"{OUT}/trimmed/{{sample}}.trimmed.fastq"
    output:
        fasta = f"{OUT}/assembly_megahit/{{sample}}/final.contigs.fa"
    params:
        outdir = f"{OUT}/assembly_megahit/{{sample}}",
        min_len = config["assembly"]["megahit"]["min_contig_len"],
        extra = config["assembly"]["megahit"]["extra"]
    threads: config["assembly"]["megahit"]["threads"]
    conda:
        "../environment.yml"
    log:
        f"{OUT}/logs/megahit/{{sample}}.log"
    shell:
        """
        
        megahit -r {input} \
                -o {params.outdir} \
                --min-contig-len {params.min_len} \
                --num-cpu-threads {threads} \
                {params.extra} 2> {log}
        
        """

rule quast:
    input:
        f"{OUT}/assembly/{{sample}}/assembly.fasta"
    output:
        report = f"{OUT}/assembly/{{sample}}/quast_report.html",
        tsv = f"{OUT}/assembly/{{sample}}/report.tsv"
    params:
        outdir = f"{OUT}/assembly/{{sample}}/quast",
        min_contig = config["quast"]["min_contig_length"]
    threads: config["quast"]["threads"]
    conda:
        "../environment.yml"
    log:
        f"{OUT}/logs/quast/{{sample}}.log"
    shell:
        """
        quast.py {input} \
                 -o {params.outdir} \
                 --threads {threads} \
                 --min-contig {params.min_contig} 2> {log} 
               
        
        cp {params.outdir}/report.html {output.report}
        cp {params.outdir}/report.tsv {output.tsv}
        """
