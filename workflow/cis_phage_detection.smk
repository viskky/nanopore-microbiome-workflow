"""
Phage-like Protein Detection Rules
"""

rule hmmsearch_cis_phage:
    input:
        proteins = f"{OUT}/annotation/{{sample}}/{{sample}}.faa",
        hmm = config["cis_phage"]["hmmsearch"]["hmm_profiles"]
    output:
        tblout = f"{OUT}/cis_phage/{{sample}}_cis_phage_hits.tsv",
        domtblout = f"{OUT}/cis_phage/{{sample}}_cis_phage_domain_hits.tsv"
    params:
        evalue = config["cis_phage"]["hmmsearch"]["evalue"],
        extra = config["cis_phage"]["hmmsearch"]["extra"]
    threads: config["cis_phage"]["hmmsearch"]["threads"]
    conda:
        "../environment.yml"
    log:
        f"{OUT}/logs/hmmsearch/{{sample}}.log"
    shell:
        """
	hmmpress {input.hmm}

        hmmsearch --tblout {output.tblout} \
                  -E {params.evalue} \
                  --cpu {threads} \
                  {input.hmm} \
                  {input.proteins} > /dev/null 2> {log}
        """

