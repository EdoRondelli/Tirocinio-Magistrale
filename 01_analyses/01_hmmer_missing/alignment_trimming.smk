# This snakefile first aligns each chosen orthogroup, then trims it using the two-step process.

configfile: "alignment_trimming.yaml"

ORTHOGROUPS = glob_wildcards("actualfilesCOX/{orthogroup}.faa")[0]

rule all:
    input:
        expand("trimmed2COX/{orthogroup}_trimmed.faa", orthogroup=ORTHOGROUPS)

rule mafft:
    input:
        OG="actualfilesCOX/{orthogroup}.faa"
    output:
        "alignedCOX/{orthogroup}_aligned.faa"   
    params:
        alg=config["alignment_params"]["algorithm"],
        typ=config["alignment_params"]["type"]
    conda: "sequence"
    shell:
        "mafft --{params.alg} --{params.typ} {input.OG} > {output}"

rule BMGE_1:
    input:
        alignment="alignedCOX/{orthogroup}_aligned.faa"
    output:
        fasta=temp("trimmed1COX/{orthogroup}_trimmed.faa"),
        html="html/{orthogroup}_trimmed.html"
    params:
        ent=config["trimming_params"]["entropy1"],
        gap=config["trimming_params"]["gaps1"],
        typ=config["trimming_params"]["type"],
        mtx=config["trimming_params"]["matrix"]
    conda: "sequence"
    shell:
        "bmge -i {input.alignment} -t {params.typ} -m {params.mtx} -h {params.ent} -g {params.gap} -of {output.fasta} -oh {output.html}"

rule BMGE_2:
    input:
        trimmed1="trimmed1COX/{orthogroup}_trimmed.faa"
    output:
        "trimmed2COX/{orthogroup}_trimmed.faa"
    params:
        ent=config["trimming_params"]["entropy2"],
        gap=config["trimming_params"]["gaps2"],
        typ=config["trimming_params"]["type"],
        mtx=config["trimming_params"]["matrix"]
    conda: "sequence"
    shell:
        "bmge -i {input.trimmed1} -t {params.typ} -m {params.mtx} -h {params.ent} -g {params.gap} -of {output}"
  
