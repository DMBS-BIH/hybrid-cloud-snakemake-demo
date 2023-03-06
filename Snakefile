from snakemake.remote.S3 import RemoteProvider as S3RemoteProvider

localrules: all, download

S3 = S3RemoteProvider(access_key_id="XXX", secret_access_key="XXX", endpoint_url="https://s3-elixir.cloud.e-infra.cz")

#adjust to your own path
outfile_s3 = "bucket/key/outfile_smk_demo.txt"
remote_file_s3 = "bucket/key/news_archimedes_el.png"

rule all:
    input:
        file="outfile_local.txt"


rule getFile:
    output:
        file=S3.remote(remote_file_s3)
    shell:
        """
        curl 'https://www.athenarc.gr/sites/default/files/styles/news_first_page_img/public/news_archimedes_el.png' --output {output.file}
        """


rule processing:
    input:
        file=S3.remote(remote_file_s3)
    output:
        file=S3.remote(outfile_s3)
    shell:
        """
        openssl dgst -md5 {input.file} > md5.txt
        openssl dgst -sha1 {input.file} > sha1.txt
        openssl dgst -sha224 {input.file} > sha224.txt
        cat md5.txt sha1.txt sha224.txt > {output.file}
        """

rule download:
    input:
        file=S3.remote(outfile_s3)
    output:
        file="outfile_local.txt"
    shell:
        """
        sleep 3
        cp {input.file} {output.file}
        """
