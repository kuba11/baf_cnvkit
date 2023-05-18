process cnvkit {

  container "etal/cnvkit"
  
  input:
  val(sample)

  output:
    path "${sample.name}_baf/${sample.name}-baf-1-scatter.png"
  
  publishDir "/mnt/shared/MedGen/GenomePD/projects/mutTP53_expansion/data/CNV/${params.date}_tumors_${sample.kit}_kuba", mode: 'copy'

  script:
  """
  if [ ${sample.kit} = "Nextera" ]
  then 
    touch "${sample.name}-baf-scatter.png"
    exit 0
  fi

  mkdir ${sample.name}_baf
  for i in {0..22} X Y
  do
  gunzip /mnt/shared/MedGen/GenomePD/projects/mutTP53_expansion/data/CNV/${params.date}_vcf/${sample.name}.vcf
  cnvkit.py scatter /mnt/shared/MedGen/GenomePD/projects/mutTP53_expansion/data/CNV/${params.date}_tumors_${sample.kit}/${sample.name}.cnr -s /mnt/shared/MedGen/GenomePD/projects/mutTP53_expansion/data/CNV/${params.date}_tumors_${sample.kit}/${sample.name}.cns --y-max=3 --y-min=-3 -o ${sample.name}_baf/${sample.name}-baf-$i-scatter.png -v /mnt/shared/MedGen/GenomePD/projects/mutTP53_expansion/data/CNV/${params.date}_vcf/${sample.name}.vcf -c chr$i
  gzip /mnt/shared/MedGen/GenomePD/projects/mutTP53_expansion/data/CNV/${params.date}_vcf/${sample.name}.vcf
  done
  """
}

workflow {
  Channel.fromList(params.tumors) | cnvkit
} 