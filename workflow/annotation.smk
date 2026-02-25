"""
Genome Annotation Rules
"""

rule prokka:
    input:
        f"{OUT}/assembly/{{sample}}/assembly.fasta"
    output:
        gbk = f"{OUT}/annotation/{{sample}}/{{sample}}.gbk",
        faa = f"{OUT}/annotation/{{sample}}/{{sample}}.faa",
        ffn = f"{OUT}/annotation/{{sample}}/{{sample}}.ffn",
        gff = f"{OUT}/annotation/{{sample}}/{{sample}}.gff",
	txt = f"{OUT}/annotation/{{sample}}/{{sample}}.txt",
	tbl = f"{OUT}/annotation/{{sample}}/{{sample}}.tbl"
    params:
        outdir = f"{OUT}/annotation/{{sample}}",
        prefix = "{sample}",
        kingdom = config["annotation"]["prokka"]["kingdom"],
        extra = config["annotation"]["prokka"]["extra"]
    threads: config["annotation"]["prokka"]["threads"]
    conda:
        "../environment.yml"
    log:
        f"{OUT}/logs/prokka/{{sample}}.log"
    shell:
        """
        prokka {input} \
               --outdir {params.outdir} \
               --prefix {params.prefix} \ # Removed the --kingdom parameter
	       --kingdom {params.kingdom} \
               --cpus {threads} \
               {params.extra} \
               --force 2> {log}
        """
