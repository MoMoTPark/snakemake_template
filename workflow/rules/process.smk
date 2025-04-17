# Rule for having two files as input with an overall output in the actual results
rule fastqc:
    input:
        r1 = lambda wildcards: read_1[wildcards.id],
        r2 = lambda wildcards: read_2[wildcards.id]
    output:
        done = "results/qc/{id}_fastqc.done",
    conda: "../envs/fastqc.yaml"
    log: "logs/fastqc_{id}.log"
    benchmark: "benchmarks/fastqc_{id}.benchmark"
    threads: 4
    shell:
        '''
        fastqc -t {threads} \
        -o results/qc/ \
        {input.r1} \
        {input.r2} 2> {log};
        touch {output.done}
        '''

# Rule for having one input
rule mapping:
    input: lambda wildcards: input_files[wildcards.id],
    output: "results/mapped/{id}_aligned.sorted.bam",
    conda: "../envs/minimap2.yaml"
    log: "logs/mapping_{id}.log"
    benchmark: "benchmarks/mapping_{id}.benchmark"
    threads: 8
    params:
        ref_fa = config['ref_fa']
    shell:
        '''
        minimap2 -t {threads} -ax map-ont {params.ref_fa} {input} | samtools sort -@ {threads} -O BAM -o {output} -;
        samtools index -@ {threads} {output} 2> {log}
        '''
