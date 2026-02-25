"""
Quality Control Rules
"""

rule fastqc_raw:
    input:
        lambda wildcards: samples_df[samples_df["sample_id"] == wildcards.sample]["fastq_file"].values[0]
    output:
        html = f"{OUT}/qc/fastqc/{{sample}}_fastqc.html",
	zip = f"{OUT}/qc/fastqc/{{sample}}_fastqc.zip"
    params:
        outdir = f"{OUT}/qc/fastqc"
    threads: config["qc"]["fastqc"]["threads"]
    conda:
        "../environment.yml"
    log:
        f"{OUT}/logs/fastqc/{{sample}}.log"
    shell:
        """
        fastqc {input} -o {params.outdir} -t {threads} 2> {log}
        """

rule porechop:
    input:
        lambda wildcards: samples_df[samples_df["sample_id"] == wildcards.sample]["fastq_file"].values[0]
    output:
        f"{OUT}/trimmed/{{sample}}.trimmed.fastq"
    threads: config["qc"]["porechop"]["threads"]
    params:
        extra = config["qc"]["porechop"]["extra"]
    conda:
        "../environment.yml"
    log:
        f"{OUT}/logs/porechop/{{sample}}.log"
    shell:
        """
        porechop -i {input} -o {output} \
                 --threads {threads} \
                 {params.extra} 2> {log}
        """

rule fastqc_trimmed:
    input:
        f"{OUT}/trimmed/{{sample}}.trimmed.fastq"
    output:
        html = f"{OUT}/qc/fastqc_trimmed/{{sample}}_trimmed_fastqc.html",
	zip = f"{OUT}/qc/fastqc_trimmed/{{sample}}_trimmed_fastqc.zip"
    params:
        outdir = f"{OUT}/qc/fastqc_trimmed"
    threads: config["qc"]["fastqc"]["threads"]
    conda:
        "../environment.yml"
    log:
        f"{OUT}/logs/fastqc_trimmed/{{sample}}.log"
    shell:
        """
        fastqc {input} -o {params.outdir} -t {threads} 2> {log}
        """

rule multiqc:
    input:
        expand(f"{OUT}/qc/fastqc/{{sample}}_fastqc.zip", sample=SAMPLES),
        expand(f"{OUT}/qc/fastqc_trimmed/{{sample}}_trimmed_fastqc.zip", sample=SAMPLES)
    output:
        f"{OUT}/qc/multiqc_report.html"
    params:
        indir = f"{OUT}/qc",
        outdir = f"{OUT}/qc"
    conda:
        "../environment.yml"
    log:
        f"{OUT}/logs/multiqc.log"
    shell:
        """
        multiqc {params.indir} -o {params.outdir} -f 2> {log}
	"""
