rule rehead_vcf:
    input:
        vcf = config["original_vcf"],
        samples_file = config["samples_file_rehead"]
    output:
        os.path.join(config["working_dir"], "mikk_rehead.vcf.gz")
    log:
        os.path.join(config["log_dir"], "rehead_vcf.log")
    container:
        config["bcftools"]
    shell:
        """
        bcftools reheader \
            --output {output[0]} \
            --samples {input.samples_file} \
            {input.vcf} \
                2> {log}
        """

rule filter_for_mikk:
    input:
        vcf = os.path.join(config["working_dir"], "mikk_rehead.vcf.gz"),
        samples_file = config["samples_file_extant_mikk"]
    output:
        os.path.join(config["working_dir"], "mikk_extant.vcf.gz"),
    log:
        os.path.join(config["log_dir"], "filter_for_mikk.log")
    container:
        config["bcftools"]
    shell:
        """
        bcftools view \
            --output-type z \
            --output {output[0]} \
            --samples-file {input.samples_file} \
            --force-samples \
            {input.vcf} \
                2> {log}
        """

rule annotate_ac:
    input:
        os.path.join(config["working_dir"], "mikk_extant.vcf.gz"),
    output:
        os.path.join(config["working_dir"], "mikk_extant_ac.vcf.gz"),
    log:
        os.path.join(config["log_dir"], "annotate_ac.log")
    params:
        extra = "--tags AC_Hom,AC_Het,AC_Hemi,F_MISSING"
    container:
        config["bcftools"]
    shell:
        """
        bcftools +fill-tags \
            {input[0]} \
            --output-type z \
            --output {output[0]} \
            -- {params.extra} \
                2> {log}
        """

rule filter_variants:
    input:
        os.path.join(config["working_dir"], "mikk_extant_ac.vcf.gz"),
    output:
        os.path.join(config["working_dir"], "mikk_filtered.vcf.gz"),
    log:
        os.path.join(config["log_dir"], "filter_variants.log"),
    params:
        max_AC_Het = config["max_AC_Het"],
        max_F_MISSING = config["max_F_MISSING"],
        min_MQ = config["min_MQ"]
    resources:
        mem_mb = 10000
    container:
        config["bcftools"]
    shell:
        """
        bcftools view \
            --include 'AC_Het<{params.max_AC_Het} & F_MISSING<{params.max_F_MISSING} & MQ>{params.min_MQ}' \
            --output-type z \
            --output {output[0]} \
            {input[0]} \
               2> {log}
        """

rule add_mikk_prefix:
    input:
        vcf = os.path.join(config["working_dir"], "mikk_filtered.vcf.gz"),
        samples_file = config["samples_file_with_prefix"]
    output:
        os.path.join(config["lts_dir"], "vcfs/mikk_clean.vcf.gz"),
    log:
        os.path.join(config["log_dir"], "add_mikk_prefix.log"),
    container:
        config["bcftools"]
    shell:
        """
        bcftools reheader \
            --output {output[0]} \
            --samples {input.samples_file} \
            {input.vcf} \
                2> {log}
        """