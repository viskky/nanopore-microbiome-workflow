"""
Taxonomic Classification Rules
"""

rule kraken2:
    input:
        f"{OUT}/trimmed/{{sample}}.trimmed.fastq"
    output:
        report = f"{OUT}/taxonomy/{{sample}}/kraken2_report.csv",
        output = f"{OUT}/taxonomy/{{sample}}/kraken2_output.csv"
    params:
        db = config["taxonomy"]["kraken2"]["database"],
        confidence = config["taxonomy"]["kraken2"]["confidence"],
        extra = config["taxonomy"]["kraken2"]["extra"]
    threads: config["taxonomy"]["kraken2"]["threads"]
    conda:
        "../environment.yml"
    log:
        f"{OUT}/logs/kraken2/{{sample}}.log"
    shell:
        """
        kraken2 --db {params.db} \
                --threads {threads} \
                --confidence {params.confidence} \
                --report {output.report} \
                --output {output.output} \
                {input}
        """

rule krona:
    input:
        f"{OUT}/taxonomy/{{sample}}/kraken2_report.csv"
    output:
        f"{OUT}/taxonomy/{{sample}}/krona.html"
    conda:
        "../environment.yml"
    log:
        f"{OUT}/logs/krona/{{sample}}.log"
    shell:
        """
        
        
        # Create krona chart.
        ktImportTaxonomy -t 5 -m 3 -o {output} {input}
        
        """

