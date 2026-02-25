"""
Antimicrobial Resistance Detection Rules
"""

rule abricate_vfdb:
    input:
        f"{OUT}/assembly/{{sample}}/assembly.fasta"
    output:
        f"{OUT}/amr/{{sample}}_vfdb.tsv"
    params:
        db = "vfdb",
        mincov = config["amr"]["abricate"]["min_coverage"],
        minid = config["amr"]["abricate"]["min_identity"]
    threads: config["amr"]["abricate"]["threads"]
    conda:
        "../environment.yml"
    log:
        f"{OUT}/logs/abricate/{{sample}}_vfdb.log"
    shell:
        """
        abricate --db {params.db} \
                 --mincov {params.mincov} \
                 --minid {params.minid} \
                 --threads {threads} \
                 {input} > {output} 2> {log}
        """

rule abricate_plasmidfinder:
    input:
        f"{OUT}/assembly/{{sample}}/assembly.fasta"
    output:
        f"{OUT}/amr/{{sample}}_plasmidfinder.tsv"
    params:
        db = "plasmidfinder",
        mincov = config["amr"]["abricate"]["min_coverage"],
        minid = config["amr"]["abricate"]["min_identity"]
    threads: config["amr"]["abricate"]["threads"]
    conda:
        "../environment.yml"
    log:
        f"{OUT}/logs/abricate/{{sample}}_plasmidfinder.log"
    shell:
        """
        abricate --db {params.db} \
                 --mincov {params.mincov} \
                 --minid {params.minid} \
                 --threads {threads} \
                 {input} > {output} 2> {log}
        """

rule abricate_ncbi:
    input:
        f"{OUT}/assembly/{{sample}}/assembly.fasta"
    output:
        f"{OUT}/amr/{{sample}}_ncbi.tsv"
    params:
        db = "ncbi",
        mincov = config["amr"]["abricate"]["min_coverage"],
        minid = config["amr"]["abricate"]["min_identity"]
    threads: config["amr"]["abricate"]["threads"]
    conda:
        "../environment.yml"
    log:
        f"{OUT}/logs/abricate/{{sample}}_ncbi.log"
    shell:
        """
        abricate --db {params.db} \
                 --mincov {params.mincov} \
                 --minid {params.minid} \
                 --threads {threads} \
                 {input} > {output} 2> {log}
        """

rule summarize_amr:
    input:
        vfdb = f"{OUT}/amr/{{sample}}_vfdb.tsv",
        plasmidfinder = f"{OUT}/amr/{{sample}}_plasmidfinder.tsv",
        ncbi = f"{OUT}/amr/{{sample}}_ncbi.tsv"
    output:
        f"{OUT}/amr/{{sample}}_amr_summary.tsv"
    conda:
        "../environment.yml"
    log:
        f"{OUT}/logs/amr_summary/{{sample}}.log"
    script:
        "../scripts/parse_amr_results.py"


