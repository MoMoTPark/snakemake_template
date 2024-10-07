# Generate a test output
rule gen_test:
    input: lambda wildcards: input_files[wildcards.id]
    output: "results/test/{id}.txt"
    # In case a conda environment is required for running this rule
    conda: "../envs/samtools_env.yaml"
    log: "results/logs/{id}_gen_test.log"
    threads: 16
    shell:
        '''
        echo "test" > {output} 2> {log}
        '''

# Generate a test output and include sample specific parameters
rule get_test_with_params:
    input: "results/test/{id}.txt"
    output: "results/test/{id}_test_with_param.txt"
    # In case singularity/apptainer is required for running this rule
    singularity: "workflow/envs/bamstats.sif"
    log: "results/logs/{id}_get_test_with_params.log"
    threads: 16
    params:
        sample = "{id}",
        add = lambda wildcards: get_sample_param(wildcards.id)
    shell:
        '''
        echo "{params.sample} {params.add}" > {output} 2> {log}
        '''

# Generate output based on the condition of an input sample
rule gen_test_conditional:
    input: "results/test/{id}_test_with_param.txt"
    output: "results/test/{id}_conditional.txt"
    log: "results/logs/{id}_gen_test_conditional.log"
    params:
        check = lambda wildcards: run_sample(wildcards.id)
    shell:
        '''
        echo "{params.check} PASS" > {output} 2> {log}
        '''
