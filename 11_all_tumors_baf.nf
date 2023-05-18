process cnvkit {

  container "etal/cnvkit"
  
  input:
  val(sample)

  output:
    path "${sample.name}-baf-scatter.png"
  
  publishDir "/mnt/shared/MedGen/GenomePD/projects/mutTP53_expansion/data/CNV/${params.date}_tumors_${sample.kit}", mode: 'copy'

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
  cnvkit.py scatter ${sample.name}.cnr -s ${sample.name}.cns --y-max=3 --y-min=-3 -o ${sample.name}_baf/${sample.name}-baf-$i-scatter.png -v ${sample.name} -c chr$i
  done
  """
}

workflow {
  Channel.fromList(params.tumors) | cnvkit
} 